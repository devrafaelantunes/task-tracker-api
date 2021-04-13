defmodule TaskTracker.ModelTest do
  use ExUnit.Case, async: true

  #alias/import
  alias TaskTracker.Model, as: Model

  #params
  @params %{task_name: "Testing",
  task_description: "TaskTracker",
  date: "10/05/2021",
  reminder: false,
  completed: false}

  #ecto setup
  setup do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Tasktracker.Repo)
  end

  #utils fun
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
      assert %Ecto.Changeset{} = changeset = create_changeset() # creating changeset
      assert changeset.valid? == true # making sure the changeset is valid
    end

    test "creating task changeset with missing params" do
      params = %{task_description: "Testing", date: "10/10/2020"}
      assert %Ecto.Changeset{} = changeset = create_changeset(params) # creating changeset
      assert changeset.valid? == false # making sure the changeset is not valid
      assert changeset_error_to_string(changeset) == "task_name: can't be blank" # translating the error and asserting it
    end

    test "creating task changeset with invalid params" do
      params = %{task_description: "Testing", date: "10/10/2020", task_name: 101}
      assert %Ecto.Changeset{} = changeset = create_changeset(params) # creating changeset
      assert changeset.valid? == false # making sure the changeset is not valid
      assert changeset_error_to_string(changeset) == "task_name: is invalid" # translating the error and asserting it
    end
  end
end
