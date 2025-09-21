defmodule Cleanalign.Accounts.UserToken do
  use Ash.Resource,
    domain: Cleanalign.Accounts,
    data_layer: AshPostgres.DataLayer

  postgres do
    table("user_tokens")
    repo(Cleanalign.Repo)
  end

  attributes do
    uuid_primary_key(:id)
    attribute(:token, :string, public?: false, allow_nil?: false, sensitive?: true)
    attribute(:type, :atom, public?: true, allow_nil?: false)
    attribute(:expires_at, :utc_datetime, public?: true, allow_nil?: false)
  end

  relationships do
    belongs_to :user, Cleanalign.Accounts.User do
      public?(true)
      allow_nil?(false)
    end
  end

  actions do
    defaults([:create, :read, :destroy])
  end
end
