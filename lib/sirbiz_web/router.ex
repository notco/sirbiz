defmodule SirbizWeb.Router do
  use SirbizWeb, :router

  import SirbizWeb.UserAuth

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {SirbizWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_scope_for_user
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", SirbizWeb do
    pipe_through :browser

    get "/", PageController, :home
  end

  # Other scopes may use custom stacks.
  # scope "/api", SirbizWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:sirbiz, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: SirbizWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end

  ## Authentication routes

  scope "/", SirbizWeb do
    pipe_through [:browser, :require_authenticated_user]

    live_session :require_authenticated_user,
      on_mount: [{SirbizWeb.UserAuth, :require_authenticated}] do
      live "/users/settings", UserLive.Settings, :edit
      live "/users/settings/confirm-email/:token", UserLive.Settings, :confirm_email
    end

    post "/users/update-password", UserSessionController, :update_password
  end

  scope "/", SirbizWeb do
    pipe_through [:browser]

    live_session :current_user,
      on_mount: [{SirbizWeb.UserAuth, :mount_current_scope}] do
      live "/users/register", UserLive.Registration, :new
      live "/users/log-in", UserLive.Login, :new
      live "/users/log-in/:token", UserLive.Confirmation, :new

      live "/profiles", ProfileLive.Index, :index
      live "/profiles/new", ProfileLive.Form, :new
      live "/profiles/:id", ProfileLive.Show, :show
      live "/profiles/:id/edit", ProfileLive.Form, :edit

      live "/services", ServiceLive.Index, :index
      live "/services/new", ServiceLive.Form, :new
      live "/services/:id", ServiceLive.Show, :show
      live "/services/:id/edit", ServiceLive.Form, :edit

      live "/venues", VenueLive.Index, :index
      live "/venues/new", VenueLive.Form, :new
      live "/venues/:id", VenueLive.Show, :show
      live "/venues/:id/edit", VenueLive.Form, :edit

      live "/availabilities", AvailabilityLive.Index, :index
      live "/availabilities/new", AvailabilityLive.Form, :new
      live "/availabilities/:id", AvailabilityLive.Show, :show
      live "/availabilities/:id/edit", AvailabilityLive.Form, :edit
    end

    post "/users/log-in", UserSessionController, :create
    delete "/users/log-out", UserSessionController, :delete
  end
end
