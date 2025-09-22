defmodule CleanalignWeb.Router do
  use CleanalignWeb, :router
  use AshAuthentication.Phoenix.Router
  import Backpex.Router
  import Phoenix.LiveView.Router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {CleanalignWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", CleanalignWeb do
    pipe_through :browser

    get "/", PageController, :home
  end

  scope "/admin" do
    pipe_through :browser

    forward "/", Backpex.Plug,
      resources: [
        CleanalignWeb.Admin.UserResource,
        CleanalignWeb.Admin.RoleResource,
        CleanalignWeb.Admin.PropertyResource,
        CleanalignWeb.Admin.ServiceCompanyResource,
        CleanalignWeb.Admin.ServiceScheduleResource
      ]
  end

  # Other scopes may use custom stacks.
  # scope "/api", CleanalignWeb do
  #   pipe_through :api
  # end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).

  scope "/" do
    pipe_through [:browser, :authentication_required]
  end
end
