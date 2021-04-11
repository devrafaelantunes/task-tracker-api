defmodule TasktrackerWeb.TaskController do
  use TasktrackerWeb, :controller

  alias TaskTracker.Internal, as: Internal
  alias TaskTracker.Model, as: Model

  def create(conn, %{"tasks" => task}) do
    case Internal.create_task(task) do
      {:ok, %Model{} = task} ->
        conn
        |> put_status(:created)
        #ß|> put_resp_header("location", Routes.task_path(conn, :show, task))
        |> render("show.json", task: task)

      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> put_view(Tasktracker.ChangesetView)
        |> render("error.json", changeset: changeset)
    end
  end

  def show(conn, %{"task_id" => task_id} = params) do
    render(conn, "show.json", task: Internal.fetch_task(task_id))
  end

  def index(conn, params) do
    render(conn, "index.json", tasks: Internal.get_tasks())
  end


end
