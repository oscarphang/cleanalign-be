defmodule Cleanalign.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      Cleanalign.Repo,
      CleanalignWeb.Telemetry,
      {DNSCluster, query: Application.get_env(:cleanalign, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Cleanalign.PubSub},
      # Start a worker by calling: Cleanalign.Worker.start_link(arg)
      # {Cleanalign.Worker, arg},
      # Start to serve requests, typically the last entry
      CleanalignWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Cleanalign.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    CleanalignWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
