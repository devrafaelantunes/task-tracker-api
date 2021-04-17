defmodule TasktrackerWeb.Router do
  use TasktrackerWeb, :router

  pipeline :api do
    plug CORSPlug, origin: "*", allow_headers: ["content-type"]
    plug :accepts, ["json"]
  end

  scope "/api", TasktrackerWeb do
    pipe_through :api

    # == CORS REQUIREMENT == #
    options "/task", TaskController, :options
    options "/task/:task_id", TaskController, :options
    options "/task/:option/:task_id", TaskController, :options
    # ==                  == #

    # Endpoints
    post "/task", TaskController, :create
    get "/task", TaskController, :index
    get "/task/:task_id", TaskController, :show
    put "/task/:option/:task_id", TaskController, :update
    delete "/task/:task_id", TaskController, :delete
  end

  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through [:fetch_session, :protect_from_forgery]
      live_dashboard "/dashboard", metrics: TasktrackerWeb.Telemetry
    end
  end
end
