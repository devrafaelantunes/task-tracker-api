defmodule TasktrackerWeb.TaskController do
  @moduledoc """
    It is mainly used to handle requests.
  """

  # - #
  use TasktrackerWeb, :controller

  # alias/imports
  alias TaskTracker.Internal, as: Internal
  alias TaskTracker.Model, as: Model
  alias TaskTracker.Utils, as: Utils

  @params %{
    task_name: "Testing",
    task_description: "TaskTracker",
    date: "10/05/2021",
    reminder: false,
    completed: false
  }

  @doc """
    Handles POST request. Creates a new task.

    It returns an error if the data inserted is not correct.
  """
  def create(conn, task = %{}) do
    task = Utils.atomify_map(task)

    updated_task = Map.merge(task, Utils.transform_date(task.date))

    case Internal.create_task(updated_task) do
      {:ok, %Model{} = task} ->
        conn
        |> put_status(:created)
        |> render("show.json", task: task)

      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> put_view(Tasktracker.ChangesetView)
        |> render("error.json", changeset: changeset)
    end
  end

  @doc """
    Handles GET request. Returns an specify task.
  """
  def show(conn, %{"task_id" => task_id} = _params) do
    render(conn, "show.json", task: Internal.fetch_task(task_id))
  end

  @doc """
    Handles PUT request. The function is used to update and toggle a certain task reminder.
  """
  def update(conn, %{"option" => option, "task_id" => task_id}) when option == "reminder" do
    {:ok, %Model{} = task} = Internal.update_reminder(task_id)

    conn
    |> render("show.json", task: task)
  end

  @doc """
    Handles PUT request. The function is used to update and complete/incomplete a certain task.
  """
  def update(conn, %{"option" => option, "task_id" => task_id}) when option == "complete_task" do
    {:ok, %Model{} = task} = Internal.update_completed(task_id)
    Internal.set_reminder_false(task_id)

    conn
    |> render("show.json", task: task)
  end

  @doc """
    Handles DELETE request. The function is used to delete an specify task.
  """
  def delete(conn, %{"task_id" => task_id}) do
    Internal.delete_task(task_id)

    conn
    |> send_resp(:no_content, "")
  end

  @doc """
    Handles GET request. Returns all tasks.
  """
  def index(conn, _params) do
    render(conn, "index.json", tasks: Internal.get_tasks())
  end
end
