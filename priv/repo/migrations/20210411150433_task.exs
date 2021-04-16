defmodule Tasktracker.Repo.Migrations.Task do
  use Ecto.Migration

  def change do
    create table(:tasks, primary_key: false) do
      add :task_id, :serial, primary_key: true
      add :task_name, :string, null: false
      add :task_description, :string
      add :date, :date
      add :reminder, :boolean
      add :completed, :boolean

      timestamps()
    end
  end
end
