defmodule Cleanalign.Accounts.UserRole do
  use Ash.Resource, domain: Cleanalign.Accounts, data_layer: AshPostgres.DataLayer

  postgres do
    table("user_roles")
    repo(Cleanalign.Repo)
  end

  attributes do
    uuid_primary_key(:id)
  end

  relationships do
    belongs_to :user, Cleanalign.Accounts.User,
      primary_key?: true,
      allow_nil?: false

    belongs_to :role, Cleanalign.Accounts.Role,
      primary_key?: true,
      allow_nil?: false
  end

  identities do
    identity(:unique_user_role, [:user_id, :role_id])
  end

  actions do
    defaults([:create, :read, :destroy])
  end
end
