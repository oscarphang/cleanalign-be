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
    import Cleanalign.RBAC
    import Ash.Policy.Check.Builtins

    policy action_type(:create) do
      authorize_if any_of([is_admin(), is_property_manager()])
    end

    policy action_type(:read) do
      authorize_if any_of([is_admin(), is_property_manager(), is_service_company()])
    end

    policy action_type(:update) do
      authorize_if any_of([is_admin(), all_of([is_property_manager(), {Ash.Policy.Check.AttributeEquals, attribute: :user_id, value: :id}])])
    end

    policy action_type(:destroy) do
      authorize_if any_of([is_admin(), all_of([is_property_manager(), {Ash.Policy.Check.AttributeEquals, attribute: :user_id, value: :id}])])
    end
  end
end
