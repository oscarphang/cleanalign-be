ExUnit.start()

# Create the test database if it doesn't exist
{:ok, _} = Application.ensure_all_started(:postgrex)
{:ok, _} = Application.ensure_all_started(:ecto_sql)

# Create the database
Mix.Task.run("ecto.create", ~w(-r Cleanalign.Repo))
# Run migrations
Mix.Task.run("ecto.migrate", ~w(-r Cleanalign.Repo))

Ecto.Adapters.SQL.Sandbox.mode(Cleanalign.Repo, :manual)
