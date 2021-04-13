defmodule TaskTracker.Internal do
  @moduledoc """
    Module created to handle the internal interation with the DB through Repo
  """

  #alias/imports
  alias TaskTracker.Model, as: Model
  alias Tasktracker.Repo

  @doc """
    Creates a valid changeset through a Model Function and then inserts into the db through the Repo.
  """
  def create_task(params) do
    Model.create_changeset(params)
    |> Repo.insert()
  end

  @doc """
    Get all the tasks values.
  """
  def get_tasks() do
    Model.query_tasks()
    |> Repo.all()
  end

  @doc """
    Get the value from a single task identified by their id.
  """
  def fetch_task(task_id) do
    Model.query_task(task_id)
    |> Repo.one()
  end

  @doc """
    Get the reminder value from a single task identified by their id.
  """
  def fetch_reminder_value(task_id) do
    Model.query_reminder(task_id)
    |> Repo.one()
  end

  @doc """
    Get the completion value from a single task identified by their id.
  """
  def fetch_completed_value(task_id) do
    Model.query_completed(task_id)
    |> Repo.one()
  end

  @doc """
    Get the tasks completion count value.
  """
  def fetch_count() do
    Model.query_count()
    |> Repo.one()
  end

  @doc """
    Updates the reminder based on their current value. If it's true update to false then vice-versa.
  """
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

  @doc """
    Set reminder value to false.
  """
  def set_reminder_false(task_id) do
    task =
      fetch_task(task_id)

    Model.update_reminder(task, false)
    |> Repo.update()
  end

  @doc """
    Updates the completion value based on their current value. If it's true update to false then vice-versa.
  """
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

  @doc """
    Delete a single task based on their id.
  """
  def delete_task(task_id) do
    fetch_task(task_id)
    |> Repo.delete()
  end
end
