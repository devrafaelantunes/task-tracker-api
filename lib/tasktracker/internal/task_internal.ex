defmodule TaskTracker.Internal do

  alias TaskTracker.Model, as: Model
  alias Tasktracker.Repo

  def create_task(params) do
    Model.create_changeset(params)
    |> Repo.insert()
  end

  def get_tasks() do
    Model.query_tasks()
    |> Repo.all()
  end

  def fetch_task(task_id) do
    Model.query_task(task_id)
    |> Repo.one()
  end

  def fetch_reminder_value(task_id) do
    Model.query_reminder(task_id)
    |> Repo.one()
  end

  def fetch_completed_value(task_id) do
    Model.query_completed(task_id)
    |> Repo.one()
  end

  def fetch_tasks_completed_value() do
    Model.query_completed_value()
    |> Repo.one()
  end

  def update_tasks_completed_value(task_id) do
    value =
      fetch_tasks_completed_value()

    Model.update_tasks_completed(task_id, value)
    |> Repo.update()
  end

  def update_reminder(task_id) do
    task =
      fetch_task(task_id)

    case fetch_reminder_value(task_id) do
      true ->
        Model.update_reminder(task, false)
        |> Repo.update()
      false ->
        Model.update_reminder(task, true)
        |> Repo.update()
    end
  end

  def update_completed(task_id) do
    task =
      fetch_task(task_id)

    case fetch_completed_value(task_id) do
      true ->
        Model.update_completed(task, false)
        |> Repo.update()
      false ->
        Model.update_completed(task, true)
        |> Repo.update()
    end
  end

  def delete_task(task_id) do
    fetch_task(task_id)
    |> Repo.delete()
  end
end
