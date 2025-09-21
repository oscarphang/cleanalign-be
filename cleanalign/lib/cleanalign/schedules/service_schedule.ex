defmodule Cleanalign.Schedules.ServiceSchedule do
  use Ash.Resource,
    domain: Cleanalign.Schedules,
    data_layer: AshPostgres.DataLayer

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
end
