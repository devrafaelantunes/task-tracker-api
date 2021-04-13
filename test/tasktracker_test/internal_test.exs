defmodule TaskTracker.InternalTest do
  use ExUnit.Case, async: true

  #alias/imports
  alias TaskTracker.Model, as: Model
  alias TaskTracker.Internal, as: Internal

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
  def create_task(params \\ @params) do
    Internal.create_task(params)
  end


  describe "creating a task" do
    test "creating task with valid params" do
      assert {:ok, %Model{} = task} = create_task() # creating task
      assert %Model{} = Internal.fetch_task(task.task_id) # fetching task to make sure it has been created
    end

    test "creating task with invalid params" do
      params = %{task_description: "Testing", date: "10/10/2020"} # params without the task_name, which is required
      assert {:error, %Ecto.Changeset{} = _changeset} = create_task(params) # asserting the error
    end
  end

  describe "testing querying and fetching" do
    test "fetching single task through the id" do
      assert {:ok, %Model{} = task} = create_task() # creating task
      assert %Model{} = Internal.fetch_task(task.task_id) # fetching task
    end

    test "getting all the tasks" do
      assert {:ok, %Model{}} = create_task() # creating task 1
      assert {:ok, %Model{}} = create_task() # creating task 2

      assert [%Model{} = _task1, %Model{} = _task2] = Internal.get_tasks() # getting all the tasks
    end

    test "fetching reminder value" do
      assert {:ok, %Model{} = task} = create_task() # creating task
      assert Internal.fetch_reminder_value(task.task_id) == false # asserting the default value(false)
    end

    test "fetching completed task value" do
      assert {:ok, %Model{} = task} = create_task() # creating task
      assert Internal.fetch_completed_value(task.task_id) == false # asserting the default value(false)
    end

    test "fetch task completed count" do
      assert {:ok, %Model{} = _task} = create_task() # creating task
      assert Internal.fetch_count == 0 # asserting to the default value(0)
    end
  end

  describe "updating values" do
    test "activating/deactivating reminder" do
      assert {:ok, %Model{} = task} = create_task() # creating task
      assert Internal.fetch_reminder_value(task.task_id) == false # asserting the default value(false)
      assert {:ok, %Model{}} = Internal.update_reminder(task.task_id) ## activating reminder (setting it to true)
      assert Internal.fetch_reminder_value(task.task_id) == true # asserting the updated value (true)
    end

    test "activating/deactivating task completion" do
      assert {:ok, %Model{} = task} = create_task() # creating task
      assert Internal.fetch_completed_value(task.task_id) == false # asserting the default value(false)
      assert {:ok, %Model{}} = Internal.update_completed(task.task_id) ## activating reminder (setting it to true)
      assert Internal.fetch_completed_value(task.task_id) == true # asserting the updated value (true)
    end

    test "setting reminder value to false" do
      assert {:ok, %Model{} = task} = create_task() # creating task
      assert {:ok, %Model{}} = Internal.update_reminder(task.task_id) # changing the value to true
      assert {:ok, %Model{}} = Internal.set_reminder_false(task.task_id) # setting to false
      assert Internal.fetch_reminder_value(task.task_id) == false # making sure the value is false
    end
  end

  test "deleting a task" do
    assert {:ok, %Model{} = task} = create_task() # creating task
    assert %Model{} = Internal.fetch_task(task.task_id) # fetching task to make sure it has been created

    assert {:ok, %Model{}} = Internal.delete_task(task.task_id) # deleting the task
    assert Internal.fetch_task(task.task_id) == nil # making sure it has been deleted
  end
end
