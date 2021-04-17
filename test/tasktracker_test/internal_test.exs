defmodule TaskTracker.InternalTest do
  use ExUnit.Case, async: true

  # alias/imports
  alias TaskTracker.Model, as: Model
  alias TaskTracker.Internal, as: Internal

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
  def create_task(params \\ @params) do
    Internal.create_task(params)
  end

  describe "creating a task" do
    test "creating task with valid params" do
      # creating task
      assert {:ok, %Model{} = task} = create_task()
      # fetching task to make sure it has been created
      assert %Model{} = Internal.fetch_task(task.task_id)
    end

    test "creating task with invalid params" do
      # params without the task_name, which is required
      params = %{task_description: "Testing", date: "10/10/2020"}
      # asserting the error
      assert {:error, %Ecto.Changeset{} = _changeset} = create_task(params)
    end
  end

  describe "testing querying and fetching" do
    test "fetching single task through the id" do
      # creating task
      assert {:ok, %Model{} = task} = create_task()
      # fetching task
      assert %Model{} = Internal.fetch_task(task.task_id)
    end

    test "getting all the tasks" do
      # creating task 1
      assert {:ok, %Model{}} = create_task()
      # creating task 2
      assert {:ok, %Model{}} = create_task()

      # getting all the tasks
      assert [%Model{} = _task1, %Model{} = _task2] = Internal.get_tasks()
    end

    test "fetching reminder value" do
      # creating task
      assert {:ok, %Model{} = task} = create_task()
      # asserting the default value(false)
      assert Internal.fetch_reminder_value(task.task_id) == false
    end

    test "fetching completed task value" do
      # creating task
      assert {:ok, %Model{} = task} = create_task()
      # asserting the default value(false)
      assert Internal.fetch_completed_value(task.task_id) == false
    end

    test "fetch task completed count" do
      # creating task
      assert {:ok, %Model{} = _task} = create_task()
      # asserting to the default value(0)
      assert Internal.fetch_count() == 0
    end
  end

  describe "updating values" do
    test "activating/deactivating reminder" do
      # creating task
      assert {:ok, %Model{} = task} = create_task()
      # asserting the default value(false)
      assert Internal.fetch_reminder_value(task.task_id) == false
      ## activating reminder (setting it to true)
      assert {:ok, %Model{}} = Internal.update_reminder(task.task_id)
      # asserting the updated value (true)
      assert Internal.fetch_reminder_value(task.task_id) == true
    end

    test "activating/deactivating task completion" do
      # creating task
      assert {:ok, %Model{} = task} = create_task()
      # asserting the default value(false)
      assert Internal.fetch_completed_value(task.task_id) == false
      ## activating reminder (setting it to true)
      assert {:ok, %Model{}} = Internal.update_completed(task.task_id)
      # asserting the updated value (true)
      assert Internal.fetch_completed_value(task.task_id) == true
    end

    test "setting reminder value to false" do
      # creating task
      assert {:ok, %Model{} = task} = create_task()
      # changing the value to true
      assert {:ok, %Model{}} = Internal.update_reminder(task.task_id)
      # setting to false
      assert {:ok, %Model{}} = Internal.set_reminder_false(task.task_id)
      # making sure the value is false
      assert Internal.fetch_reminder_value(task.task_id) == false
    end
  end

  test "deleting a task" do
    # creating task
    assert {:ok, %Model{} = task} = create_task()
    # fetching task to make sure it has been created
    assert %Model{} = Internal.fetch_task(task.task_id)

    # deleting the task
    assert {:ok, %Model{}} = Internal.delete_task(task.task_id)
    # making sure it has been deleted
    assert Internal.fetch_task(task.task_id) == nil
  end
end
