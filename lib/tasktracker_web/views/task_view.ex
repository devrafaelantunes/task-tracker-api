defmodule TasktrackerWeb.TaskView do
  use TasktrackerWeb, :view

  def render("show.json", %{task: task}) do
    %{data: render_one(task, __MODULE__, "task.json")}
  end

  def render("task.json", %{task: task}) do
    %{
      task_id: task.task_id,
      task_name: task.task_name,
      date: task.date,
      reminder: task.reminder
    }

  end
end
