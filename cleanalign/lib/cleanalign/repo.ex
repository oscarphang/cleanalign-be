defmodule Cleanalign.Repo do
  use Ecto.Repo,
    otp_app: :cleanalign,
    adapter: Ecto.Adapters.Postgres

  def installed_extensions() do
    ["ash-functions", "uuid-ossp", "citext"]
  end
end
