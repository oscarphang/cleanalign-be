defmodule CleanalignWeb.Admin.RoleResource do
  use Backpex.LiveResource,
    adapter: Backpex.Adapters.Ash,
    layout: {CleanalignWeb.Layouts, :app},
    adapter_config: [
      resource: Cleanalign.Accounts.Role
    ]

  def singular_name, do: "Role"
  def plural_name, do: "Roles"
end
