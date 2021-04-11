defmodule TaskTracker.Internal do

  alias TaskTracker.Model, as: Model
  alias Tasktracker.Repo

  import Ecto.Query

  def create_task(params) do
    Model.create_changeset(params)
    |> Repo.insert()
  end

  def get_tasks() do
    query =
      from(t in Model,
      select: t)

    Repo.all(query)
  end

  def fetch_task(task_id) do
    query =
    from(t in Model,
      select: t,
      where: t.task_id == ^task_id
    )

    |> Repo.one()
  end


end
