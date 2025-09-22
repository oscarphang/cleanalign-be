defmodule Cleanalign.Schedules.ServiceSchedule do
  use Ash.Resource,
    domain: Cleanalign.Schedules,
    data_layer: AshPostgres.DataLayer,
    authorizers: []

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
  end

  validations do
    validate fn changeset, _context ->
      service_at = Ash.Changeset.get_field(changeset, :service_at)
      cutoff_day = Ash.Changeset.get_field(changeset, :cutoff_day)
      today = Date.utc_today()

      if service_at && cutoff_day && Date.after?(service_at |> NaiveDateTime.to_date(), today |> Date.end_of_month()) do
        if Date.day(today) >= cutoff_day do
          {:error, "Scheduling for the next month is not allowed after the cutoff day."}
        else
          :ok
        end
      else
        :ok
      end
    end

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
end
