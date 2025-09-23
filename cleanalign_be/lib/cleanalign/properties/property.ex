defmodule Cleanalign.Properties.Property do
  use Ash.Resource,
    domain: Cleanalign.Properties,
    data_layer: AshPostgres.DataLayer,
    authorizers: [Ash.Policy.Authorizer]

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

  policies do
    require Cleanalign.RBAC

    policy action_type(:create) do
      authorize_if expr(is_admin(actor()) or is_property_manager(actor()))
    end

    policy action_type(:read) do
      authorize_if expr(is_admin(actor()) or is_property_manager(actor()) or is_service_company(actor()))
    end

    policy action_type(:update) do
      authorize_if expr(is_admin(actor()) or (is_property_manager(actor()) and actor().id == record.user_id))
    end

    policy action_type(:destroy) do
      authorize_if expr(is_admin(actor()) or (is_property_manager(actor()) and actor().id == record.user_id))
    end

    policy action_type(:read) do
      authorize_if expr(is_service_company(actor()) and actor().id == record.service_company_id)
    end
  end
end
