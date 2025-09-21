# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :cleanalign,
  ecto_repos: [Cleanalign.Repo],
  generators: [timestamp_type: :utc_datetime]

config :cleanalign, ash_domains: [Cleanalign.Accounts]

# Configures the endpoint
config :cleanalign, CleanalignWeb.Endpoint,
  url: [host: "localhost"],
  adapter: Bandit.PhoenixAdapter,
  render_errors: [
    formats: [json: CleanalignWeb.ErrorJSON],
    layout: false
  ],
  pubsub_server: Cleanalign.PubSub,
  live_view: [signing_salt: "QLavA941"]

# Configure esbuild (the version is required)
config :esbuild,
  version: "0.25.4",
  cleanalign: [
    args:
      ~w(js/app.js --bundle --target=es2022 --outdir=../priv/static/assets/js --external:/fonts/* --external:/images/* --alias:@=.),
    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => [Path.expand("../deps", __DIR__), Mix.Project.build_path()]}
  ]

# Configure tailwind (the version is required)
config :tailwind,
  version: "4.1.7",
  cleanalign: [
    args: ~w(
      --input=assets/css/app.css
      --output=priv/static/assets/css/app.css
    ),
    cd: Path.expand("..", __DIR__)
  ]

# Configures Elixir's Logger
config :logger, :default_formatter,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Configure the Repo
config :cleanalign, Cleanalign.Repo,
  database: "cleanalign_#{config_env()}",
  username: "pnd",
  password: "vsjcTRkHS4N4gzsX",
  hostname: "127.0.0.1",
  show_sensitive_data_on_connection_error: true,
  pool_size: 10

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
