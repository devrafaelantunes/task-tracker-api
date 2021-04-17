defmodule TaskTracker.ModelTest do
  use ExUnit.Case, async: true

  # alias/import
  alias TaskTracker.Model, as: Model

  # params
  @params %{
    task_name: "Testing",
    task_description: "TaskTracker",
    date: "10/05/2021",
    reminder: false,
    completed: false
  }

  # ecto setup
  setup do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Tasktracker.Repo)
  end

  # utils fun
  def create_changeset(params \\ @params) do
    Model.create_changeset(params)
  end

  # Translate Changeset Errors Function
  defp changeset_error_to_string(changeset) do
    Ecto.Changeset.traverse_errors(changeset, fn {msg, opts} ->
      Enum.reduce(opts, msg, fn {key, value}, acc ->
        String.replace(acc, "%{#{key}}", to_string(value))
      end)
    end)
    |> Enum.reduce("", fn {k, v}, acc ->
      joined_errors = Enum.join(v, "; ")
      "#{acc}#{k}: #{joined_errors}"
    end)
  end

  describe "creating changeset" do
    test "creating task changeset with valid params" do
      # creating changeset
      assert %Ecto.Changeset{} = changeset = create_changeset()
      # making sure the changeset is valid
      assert changeset.valid? == true
    end

    test "creating task changeset with missing params" do
      params = %{task_description: "Testing", date: "10/10/2020"}
      # creating changeset
      assert %Ecto.Changeset{} = changeset = create_changeset(params)
      # making sure the changeset is not valid
      assert changeset.valid? == false
      # translating the error and asserting it
      assert changeset_error_to_string(changeset) == "task_name: can't be blank"
    end

    test "creating task changeset with invalid params" do
      params = %{task_description: "Testing", date: "10/10/2020", task_name: 101}
      # creating changeset
      assert %Ecto.Changeset{} = changeset = create_changeset(params)
      # making sure the changeset is not valid
      assert changeset.valid? == false
      # translating the error and asserting it
      assert changeset_error_to_string(changeset) == "task_name: is invalid"
    end
  end
end
