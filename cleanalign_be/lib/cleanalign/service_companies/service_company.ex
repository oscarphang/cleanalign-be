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
    require Cleanalign.RBAC

    policy action_type(:create) do
      authorize_if expr(is_admin(actor()) or is_service_company(actor()))
    end

    policy action_type(:read) do
      authorize_if expr(is_admin(actor()) or is_service_company(actor()) or is_property_manager(actor()))
    end

    policy action_type(:update) do
      authorize_if expr(is_admin(actor()) or (is_service_company(actor()) and actor().id == record.user_id))
    end

    policy action_type(:destroy) do
      authorize_if expr(is_admin(actor()) or (is_service_company(actor()) and actor().id == record.user_id))
    end

    policy action_type(:read) do
      authorize_if expr(is_property_manager(actor()))
    end
  end
end
