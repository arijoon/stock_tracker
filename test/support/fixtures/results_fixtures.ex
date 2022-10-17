defmodule StockTracker.ResultsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `StockTracker.Results` context.
  """

  @doc """
  Generate a result.
  """
  def result_fixture(attrs \\ %{}) do
    {:ok, result} =
      attrs
      |> Enum.into(%{
        message: "some message",
        name: "some name",
        payload: "some payload"
      })
      |> StockTracker.Results.create_result()

    result
  end
end
