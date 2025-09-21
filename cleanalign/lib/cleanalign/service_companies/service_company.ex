defmodule Cleanalign.ServiceCompanies.ServiceCompany do
  use Ash.Resource,
    domain: Cleanalign.ServiceCompanies,
    data_layer: AshPostgres.DataLayer

  postgres do
    table("service_companies")
    repo(Cleanalign.Repo)
  end

  attributes do
    uuid_primary_key(:id)
    attribute(:name, :string, allow_nil?: false)
    attribute(:cutoff_day, :integer, allow_nil?: false, constraints: [min: 1, max: 31])
  end
end
