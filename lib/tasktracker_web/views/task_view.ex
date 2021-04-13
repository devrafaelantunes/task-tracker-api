defmodule TasktrackerWeb.TaskView do
  @moduledoc """
    Task view. Rendering data to the client
  """
  # - #
  use TasktrackerWeb, :view

  # alias/import
  alias TaskTracker.Internal, as: Internal

  @doc """
    Render multiple tasks.
  """
  def render("index.json", %{tasks: tasks}) do
    %{data: render_many(tasks, __MODULE__, "task.json")}
  end

  @doc """
    Render single task.
  """
  def render("show.json", %{task: task}) do
    %{data: render_one(task, __MODULE__, "task.json")}
  end

  @doc """
    Response sent to the client when creating a new task.
  """
  def render("task.json", %{task: task}) do
    %{
      task_id: task.task_id,
      task_name: task.task_name,
      date: task.date,
      reminder: task.reminder,
      task_description: task.task_description,
      task_completed: task.completed,
      task_count: Internal.fetch_count()
    }
  end
end
