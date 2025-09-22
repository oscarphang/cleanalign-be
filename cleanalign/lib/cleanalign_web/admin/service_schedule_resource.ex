defmodule CleanalignWeb.Admin.ServiceScheduleResource do
  use Backpex.LiveResource,
    adapter: Backpex.Adapters.Ash,
    layout: {CleanalignWeb.Layouts, :app},
    adapter_config: [
      resource: Cleanalign.Schedules.ServiceSchedule
    ]

  def singular_name, do: "Service Schedule"
  def plural_name, do: "Service Schedules"
end
