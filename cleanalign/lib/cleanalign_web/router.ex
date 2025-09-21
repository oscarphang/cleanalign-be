defmodule CleanalignWeb.Router do
  use CleanalignWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", CleanalignWeb do
    pipe_through :api
  end
end
