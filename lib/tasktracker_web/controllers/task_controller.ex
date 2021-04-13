defmodule TasktrackerWeb.TaskController do
  use TasktrackerWeb, :controller

  alias TaskTracker.Internal, as: Internal
  alias TaskTracker.Model, as: Model

  def create(conn, task = %{}) do
    IO.inspect(task)
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

  def show(conn, %{"task_id" => task_id} = _params) do
    render(conn, "show.json", task: Internal.fetch_task(task_id))
  end

  def update(conn, %{"option" => option, "task_id" => task_id}) when option == "reminder" do
    case Internal.update_reminder(task_id) do
      {:ok, %Model{} = task} ->
        conn
        |> render("show.json", task: task)

      true ->
        conn

    end
  end

  def update(conn, %{"option" => option, "task_id" => task_id}) when option == "complete_task" do
    case Internal.update_completed(task_id) do
      {:ok, %Model{} = task} ->
        Internal.set_reminder_false(task_id)

        conn
        |> render("show.json", task: task)

      true ->
        conn
    end
  end

  def delete(conn, %{"task_id" => task_id}) do
    Internal.delete_task(task_id)

    conn
    |> send_resp(:no_content, "")

  end

  def index(conn, _params) do
    render(conn, "index.json", tasks: Internal.get_tasks())
  end


end
