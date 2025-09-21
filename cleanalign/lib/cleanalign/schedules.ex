defmodule Cleanalign.Schedules do
  use Ash.Domain

  resources do
    resource Cleanalign.Schedules.ServiceSchedule
  end
end
