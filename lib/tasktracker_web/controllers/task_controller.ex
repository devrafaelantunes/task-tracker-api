defmodule TasktrackerWeb.TaskController do
  use TasktrackerWeb, :controller

  alias TaskTracker.Internal, as: Internal
  alias TaskTracker.Model, as: Model

  def create(conn, %{"tasks" => task}) do
    {:ok, %Model{} = task} = Internal.create_task(task)

    conn
    |> put_status(:created)
    |> render("show.json", task: task)
  end


end
