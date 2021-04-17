defmodule TaskTracker.Model do
  @moduledoc """
    Module created to handle the Task Schema + Queries
  """

  # alias/imports
  use Ecto.Schema
  import Ecto.{Changeset, Query}

  # - #
  @tasks TaskTracker.Model

  # Task Schema
  # task_id as primary key
  @primary_key {:task_id, :id, autogenerate: true}
  schema "tasks" do
    field :task_name, :string
    field :task_description, :string
    field :date, :date
    field :reminder, :boolean, default: false
    field :completed, :boolean, default: false

    timestamps()
  end

  @doc """
    Recieve params from the client and returns a valid changeset ready to be inserted into the db.
  """
  def create_changeset(params) do
    %__MODULE__{}
    |> cast(params, [:task_name, :task_description, :date, :reminder, :completed])
    |> validate_required([:task_name, :date, :reminder])
    # |> unique_constraint(:task_name)
    |> validate_length(:task_name, max: 100)
    |> validate_length(:task_description, max: 250)
  end

  @doc """
    Update the reminder value (true/false).
  """
  def update_reminder(task, value) do
    change(task, reminder: value)
  end

  @doc """
    Update the task completion value (true/false).
  """
  def update_completed(task, value) do
    change(task, completed: value)
  end

  @doc """
    Query used to get the number of tasks completed.
  """
  def query_count() do
    from t in @tasks, select: count(t.completed), where: t.completed == true
  end

  @doc """
    Query used to get the reminder value.
  """
  def query_reminder(task_id) do
    from(t in @tasks,
      select: t.reminder,
      where: t.task_id == ^task_id
    )
  end

  @doc """
    Query used to get the task completed value.
  """
  def query_completed(task_id) do
    from(t in @tasks,
      select: t.completed,
      where: t.task_id == ^task_id
    )
  end

  @doc """
    Query single task through the id.
  """
  def query_task(task_id) do
    from(t in @tasks,
      select: t,
      where: t.task_id == ^task_id
    )
  end

  @doc """
    Querying all the tasks and sorting them by task_id and their completion status
  """
  def query_tasks() do
    from(t in @tasks,
      select: t,
      order_by: [t.completed, t.task_id]
    )
  end

  @doc """
    Querying all tasks that holds the completed value true.
  """
  def query_completed_value(task_id) do
    from(t in @tasks,
      select: t.tasks_completed,
      where: t.task_id == ^task_id
    )
  end
end
