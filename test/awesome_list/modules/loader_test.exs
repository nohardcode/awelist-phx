defmodule AwesomeList.LoaderTest do
  use ExUnit.Case
  use AwesomeList.DataCase
  alias AwesomeList.{Repo, Loader, Awesome, Scheduler}

  describe "get_and_save_list/0" do
    setup do
      Loader.get_and_save_list()
      :ok
    end

    test "should save correct categories length in database" do
      categories = Repo.all(Awesome.Category)
      assert length(categories) == 2
    end

    test "should save correct awesome items length in database" do
      awesome_items = Repo.all(Awesome.Item)
      assert length(awesome_items) == 3
    end

  end


  describe "scheduler" do

    test "should log scheduler task" do
      tasks_before = Repo.all(Awesome.SchedulerTask)
      Loader.get_and_save_list()
      tasks_after = Repo.all(Awesome.SchedulerTask)
      assert length(tasks_before) == length(tasks_after) - 1
    end

    test "should create log with completed_at" do
      Loader.get_and_save_list()
      last_task = Scheduler.get_last_task()
      assert DateTime.diff(last_task.completed_at, DateTime.utc_now) < 60
    end

  end
end
