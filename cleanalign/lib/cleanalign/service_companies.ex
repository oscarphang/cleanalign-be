defmodule Cleanalign.ServiceCompanies do
  use Ash.Domain

  resources do
    resource Cleanalign.ServiceCompanies.ServiceCompany
  end
end
