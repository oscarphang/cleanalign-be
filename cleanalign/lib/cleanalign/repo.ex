defmodule Cleanalign.Repo do
  use Ecto.Repo,
    otp_app: :cleanalign,
    adapter: Ecto.Adapters.Postgres
end
