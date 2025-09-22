defmodule CleanalignWeb.Admin.ServiceCompanyResource do
  use Backpex.LiveResource,
    adapter: Backpex.Adapters.Ash,
    layout: {CleanalignWeb.Layouts, :app},
    adapter_config: [
      resource: Cleanalign.ServiceCompanies.ServiceCompany
    ]

  def singular_name, do: "Service Company"
  def plural_name, do: "Service Companies"
end
