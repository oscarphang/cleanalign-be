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
    import Ash.Policy.Authorizer

    policy action_type(:manage) do
      authorize_if check(&Cleanalign.RBAC.is_admin/2)
    end
  end
end
