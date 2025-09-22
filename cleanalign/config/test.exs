import Config

# Configure your database
config :cleanalign, Cleanalign.Repo,
  database: "cleanalign_test#{System.get_env("MIX_TEST_PARTITION")}",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: 10

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :cleanalign, CleanalignWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "pJDOrS78lf6I+I2I4pi+GlA42dT1dkfliH4Lr8h532A4K/2AFiGe0+yTMihkjHYa",
  server: false

# Print only warnings and errors during test
config :logger, level: :warning

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
