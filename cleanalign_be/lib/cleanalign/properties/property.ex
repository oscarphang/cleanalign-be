defmodule Cleanalign.Properties.Property do
  use Ash.Resource,
    domain: Cleanalign.Properties,
    data_layer: AshPostgres.DataLayer,
    authorizers: []

  postgres do
    table "properties"
    repo Cleanalign.Repo
  end

  attributes do
    uuid_primary_key(:id)
    attribute(:name, :string, allow_nil?: false)
    attribute(:building_name, :string)
    attribute(:description, :string)
    attribute(:max_pax, :integer, allow_nil?: false, constraints: [min: 1])
    attribute(:calendar_url, :string)
  end

  relationships do
    belongs_to(:user, Cleanalign.Accounts.User,
      attribute_type: :uuid,
      allow_nil?: false
    )

    belongs_to(:service_company, Cleanalign.ServiceCompanies.ServiceCompany,
      attribute_type: :uuid,
      # Can be unassigned initially
      allow_nil?: true
    )
  end
end
