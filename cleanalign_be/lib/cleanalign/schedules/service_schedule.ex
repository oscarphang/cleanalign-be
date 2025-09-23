defmodule Cleanalign.Schedules.ServiceSchedule do
  use Ash.Resource,
    domain: Cleanalign.Schedules,
    data_layer: AshPostgres.DataLayer,
    authorizers: [Ash.Policy.Authorizer]

  postgres do
    table "service_schedules"
    repo Cleanalign.Repo
  end

  attributes do
    uuid_primary_key :id
    attribute :service_at, :utc_datetime, allow_nil?: false
    attribute :is_back_to_back, :boolean, default: false, allow_nil?: false
    attribute :remark, :string
    attribute :pax, :integer, allow_nil?: false, constraints: [min: 1]
  end

  relationships do
    belongs_to :property, Cleanalign.Properties.Property,
      attribute_type: :uuid,
      allow_nil?: false
  end

  calculations do
    calculate :cutoff_day, :integer, expr(property.service_company.cutoff_day)
    calculate :calendar_url, :string, expr(property.calendar_url)

    calculate :in_reporting_period?, :boolean, Cleanalign.Schedules.ServiceSchedule
  end

  validations do
    validate fn changeset, _context ->
      calendar_url = Ash.Changeset.get_field(changeset, :calendar_url)
      service_at = Ash.Changeset.get_field(changeset, :service_at)

      if calendar_url && service_at do
        case Req.get(calendar_url) do
          {:ok, %{status: 200, body: body}} ->
            case Exical.parse_from_ical(body) do
              {:ok, calendar} ->
                conflicting_event? =
                  Enum.any?(calendar.events, fn event ->
                    event_starts = event.dtstart.value
                    event_ends = event.dtend.value

                    (DateTime.compare(service_at, event_starts) == :gt && DateTime.compare(service_at, event_ends) == :lt)
                  end)

                if conflicting_event? do
                  {:error, "There is a conflict with an external calendar event."}
                else
                  :ok
                end
              {:error, _} ->
                :ok
            end
          _ ->
            :ok
        end
      else
        :ok
      end
    end
  end

  policies do
    import Cleanalign.RBAC
    import Ash.Policy.Check.Builtins

    policy action_type(:create) do
      authorize_if any_of([is_admin(), is_property_manager()])
    end

    policy action_type(:read) do
      authorize_if any_of([is_admin(), is_property_manager(), is_service_company()])
    end

    policy action_type(:update) do
      authorize_if any_of([is_admin(), all_of([is_property_manager(), {Ash.Policy.Check.AttributeEquals, attribute: "property.user_id", value: :id}])])
    end

    policy action_type(:destroy) do
      authorize_if any_of([is_admin(), all_of([is_property_manager(), {Ash.Policy.Check.AttributeEquals, attribute: "property.user_id", value: :id}])])
    end
  end

  def calculate(records, _opts, context) do
    today = context[:today] || Date.utc_today()

    Enum.map(records, fn record ->
      cutoff_day = record.property.service_company.cutoff_day
      service_at_date = DateTime.to_date(record.service_at)

      start_of_this_month = Date.beginning_of_month(today)
      start_of_last_month = Timex.shift(start_of_this_month, months: -1)

      reporting_start_date =
        if today.day >= cutoff_day do
          %Date{year: start_of_this_month.year, month: start_of_this_month.month, day: cutoff_day}
        else
          %Date{year: start_of_last_month.year, month: start_of_last_month.month, day: cutoff_day}
        end

      reporting_end_date = Timex.shift(reporting_start_date, months: 1)

      Date.compare(service_at_date, reporting_start_date) != :lt && Date.compare(service_at_date, reporting_end_date) == :lt
    end)
  end
end
