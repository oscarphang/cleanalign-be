defmodule CleanalignWeb.Admin.PropertyResource do
  use Backpex.LiveResource,
    adapter: Backpex.Adapters.Ash,
    layout: {CleanalignWeb.Layouts, :app},
    adapter_config: [
      resource: Cleanalign.Properties.Property
    ]

  def singular_name, do: "Property"
  def plural_name, do: "Properties"
end
