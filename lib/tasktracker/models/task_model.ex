defmodule TaskTracker.Model do
  use Ecto.Schema
  import Ecto.Changeset


  # Planejar put, delete, enfim...
  # Task Schema
  @primary_key{:task_id, :id, autogenerate: true}
  schema "tasks" do
    field :task_name, :string
    field :task_description, :string
    field :date, :string
    field :reminder, :boolean, default: false

    timestamps()
  end

  # How to handle dates ecto.
  # Completar Task
  # Create Changeset
  def create_changeset(params) do
    %__MODULE__{}
    |> cast(params, [:task_name, :task_description, :date, :reminder])
    |> validate_required([:task_name, :date, :reminder])
    #|> unique_constraint(:task_name)
    |> validate_length(:task_name, max: 100)
    |> validate_length(:task_description, max: 250)
    |> validate_length(:date, min: 10, max: 10)
  end
end