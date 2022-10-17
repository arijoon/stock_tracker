defmodule StockTracker.ResultsTest do
  use StockTracker.DataCase

  alias StockTracker.Results

  describe "results" do
    alias StockTracker.Results.Result

    import StockTracker.ResultsFixtures

    @invalid_attrs %{message: nil, name: nil, payload: nil}

    test "list_results/0 returns all results" do
      result = result_fixture()
      assert Results.list_results() == [result]
    end

    test "get_result!/1 returns the result with given id" do
      result = result_fixture()
      assert Results.get_result!(result.id) == result
    end

    test "create_result/1 with valid data creates a result" do
      valid_attrs = %{message: "some message", name: "some name", payload: "some payload"}

      assert {:ok, %Result{} = result} = Results.create_result(valid_attrs)
      assert result.message == "some message"
      assert result.name == "some name"
      assert result.payload == "some payload"
    end

    test "create_result/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Results.create_result(@invalid_attrs)
    end

    test "update_result/2 with valid data updates the result" do
      result = result_fixture()
      update_attrs = %{message: "some updated message", name: "some updated name", payload: "some updated payload"}

      assert {:ok, %Result{} = result} = Results.update_result(result, update_attrs)
      assert result.message == "some updated message"
      assert result.name == "some updated name"
      assert result.payload == "some updated payload"
    end

    test "update_result/2 with invalid data returns error changeset" do
      result = result_fixture()
      assert {:error, %Ecto.Changeset{}} = Results.update_result(result, @invalid_attrs)
      assert result == Results.get_result!(result.id)
    end

    test "delete_result/1 deletes the result" do
      result = result_fixture()
      assert {:ok, %Result{}} = Results.delete_result(result)
      assert_raise Ecto.NoResultsError, fn -> Results.get_result!(result.id) end
    end

    test "change_result/1 returns a result changeset" do
      result = result_fixture()
      assert %Ecto.Changeset{} = Results.change_result(result)
    end
  end
end
