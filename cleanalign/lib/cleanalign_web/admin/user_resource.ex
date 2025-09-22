defmodule CleanalignWeb.Admin.UserResource do
  use Backpex.LiveResource,
    adapter: Backpex.Adapters.Ash,
    layout: {CleanalignWeb.Layouts, :app},
    adapter_config: [
      resource: Cleanalign.Accounts.User
    ]

  def singular_name, do: "User"
  def plural_name, do: "Users"
end
