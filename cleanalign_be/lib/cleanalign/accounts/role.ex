defmodule Cleanalign.Accounts.Role do
  use Ash.Resource,
    domain: Cleanalign.Accounts,
    data_layer: AshPostgres.DataLayer,
    authorizers: [Ash.Policy.Authorizer]

  postgres do
    table("roles")
    repo(Cleanalign.Repo)
  end

  attributes do
    uuid_primary_key(:id)
    attribute(:name, :atom,
      allow_nil?: false,
      public?: true,
      constraints: [one_of: [:superuser, :property_manager, :service_company]]
    )
  end

  identities do
    identity(:unique_name, [:name])
  end

  actions do
    defaults([:create, :read, :destroy])
  end

  policies do
    import Cleanalign.RBAC
    import Ash.Policy.Check.Builtins

    policy action_type(:create) do
      authorize_if is_admin()
    end

    policy action_type(:read) do
      authorize_if is_admin()
    end

    policy action_type(:update) do
      authorize_if is_admin()
    end

    policy action_type(:destroy) do
      authorize_if is_admin()
    end
  end
end
