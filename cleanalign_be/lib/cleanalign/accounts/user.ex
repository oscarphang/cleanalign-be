defmodule Cleanalign.Accounts.User do
  use Ash.Resource,
    domain: Cleanalign.Accounts,
    data_layer: AshPostgres.DataLayer,
    extensions: [AshAuthentication],
    authorizers: [Ash.Policy.Authorizer]

  postgres do
    table("users")
    repo(Cleanalign.Repo)
  end

  attributes do
    uuid_primary_key(:id)
    attribute(:email, :ci_string, public?: true, allow_nil?: false)
    attribute(:hashed_password, :string, allow_nil?: false, sensitive?: true)
  end

  relationships do
    many_to_many(:roles, Cleanalign.Accounts.Role,
      through: Cleanalign.Accounts.UserRole,
      source_attribute_on_join_resource: :user_id,
      destination_attribute_on_join_resource: :role_id
    )
  end

  authentication do
    strategies do
      password :password do
        identity_field(:email)
        hashed_password_field(:hashed_password)
      end
    end

    tokens do
      enabled?(true)
      token_resource(Cleanalign.Accounts.UserToken)
      require_token_presence_for_authentication?(true)
    end
  end

  identities do
    identity(:unique_email, [:email])
  end

  policies do
    import Cleanalign.RBAC
    import Ash.Policy.Check.Builtins

    policy action_type(:create) do
      authorize_if is_admin()
    end

    policy action_type(:update) do
      authorize_if is_admin()
    end

    policy action_type(:destroy) do
      authorize_if is_admin()
    end

    policy action_type(:read) do
      authorize_if {Ash.Policy.Check.AttributeEquals, attribute: :id, value: :id}
    end

    policy action(:update) do
      authorize_if {Ash.Policy.Check.AttributeEquals, attribute: :id, value: :id}
    end
  end
end
