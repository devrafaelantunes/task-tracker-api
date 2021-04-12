defmodule TasktrackerWeb.Router do
  use TasktrackerWeb, :router

  pipeline :api do
    plug CORSPlug, origin: "*", allow_headers: ["content-type"]
    plug :accepts, ["json"]


  end

  scope "/api", TasktrackerWeb do
    pipe_through :api

    options "/task", TaskController, :options
    options "/task/:task_id", TaskController, :options
    post "/task", TaskController, :create
    get "/task/:task_id", TaskController, :show
    put "/task/:task_id", TaskController, :update
    delete "/task/:task_id", TaskController, :delete
    get "/task", TaskController, :index
  end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through [:fetch_session, :protect_from_forgery]
      live_dashboard "/dashboard", metrics: TasktrackerWeb.Telemetry
    end
  end
end
