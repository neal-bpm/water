defmodule WaterWeb.Router do
  use WaterWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {WaterWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", WaterWeb do
    pipe_through :browser

    get "/", PageController, :home

    live "/shoes", ShoeLive.Index, :index
    live "/shoes/new", ShoeLive.Index, :new
    live "/shoes/:id/edit", ShoeLive.Index, :edit

    live "/shoes/:id", ShoeLive.Show, :show
    live "/shoes/:id/show/edit", ShoeLive.Show, :edit
  end

  # Other scopes may use custom stacks.
  # scope "/api", WaterWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:water, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: WaterWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
