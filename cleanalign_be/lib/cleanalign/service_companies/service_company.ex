defmodule Cleanalign.ServiceCompanies.ServiceCompany do
  use Ash.Resource,
    domain: Cleanalign.ServiceCompanies,
    data_layer: AshPostgres.DataLayer,
    authorizers: [Ash.Policy.Authorizer]

  postgres do
    table("service_companies")
    repo(Cleanalign.Repo)
  end

  attributes do
    uuid_primary_key(:id)
    attribute(:name, :string, allow_nil?: false)
    attribute(:cutoff_day, :integer, allow_nil?: false, constraints: [min: 1, max: 31])
  end

  relationships do
    belongs_to :user, Cleanalign.Accounts.User,
      attribute_type: :uuid,
      allow_nil?: false
  end

  policies do
    import Cleanalign.RBAC
    import Ash.Policy.Check.Builtins

    policy action_type(:create) do
      authorize_if any_of([is_admin(), is_service_company()])
    end

    policy action_type(:read) do
      authorize_if any_of([is_admin(), is_service_company(), is_property_manager()])
    end

    policy action_type(:update) do
      authorize_if any_of([is_admin(), all_of([is_service_company(), {Ash.Policy.Check.AttributeEquals, attribute: :user_id, value: :id}])])
    end

    policy action_type(:destroy) do
      authorize_if any_of([is_admin(), all_of([is_service_company(), {Ash.Policy.Check.AttributeEquals, attribute: :user_id, value: :id}])])
    end
  end
end
