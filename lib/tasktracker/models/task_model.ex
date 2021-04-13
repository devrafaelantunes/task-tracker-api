defmodule TaskTracker.Model do
  use Ecto.Schema
  import Ecto.{Changeset, Query}

  @tasks TaskTracker.Model


  # Planejar put, delete, enfim...
  # Task Schema
  @primary_key{:task_id, :id, autogenerate: true}
  schema "tasks" do
    field :task_name, :string
    field :task_description, :string
    field :date, :string
    field :reminder, :boolean, default: false
    field :completed, :boolean, default: false

    timestamps()
  end

  # How to handle dates ecto.
  # Completar Task
  # Create Changeset
  def create_changeset(params) do
    %__MODULE__{}
    |> cast(params, [:task_name, :task_description, :date, :reminder, :completed])
    |> validate_required([:task_name, :date, :reminder])
    #|> unique_constraint(:task_name)
    |> validate_length(:task_name, max: 100)
    |> validate_length(:task_description, max: 250)
    #|> validate_length(:date, min: 10, max: 10)
  end

  def update_reminder(task, value) do
    change(task, reminder: value)
  end

  def update_completed(task, value) do
    change(task, completed: value)
  end

  def query_count() do
    from t in @tasks, select: count(t.completed), where: t.completed == true
  end

  def query_reminder(task_id) do
    from(t in @tasks,
      select: t.reminder,
        where: t.task_id == ^task_id
  )
  end

  def query_completed(task_id) do
    from(t in @tasks,
      select: t.completed,
        where: t.task_id == ^task_id
    )

  end

  def query_task(task_id) do
    from(t in @tasks,
      select: t,
        where: t.task_id == ^task_id
  )
  end

  def query_tasks() do
    from(t in @tasks,
      select: t)
  end

  def query_completed_value(task_id) do
    from(t in @tasks,
      select: t.tasks_completed,
        where: t.task_id == ^task_id
    )
  end
end
