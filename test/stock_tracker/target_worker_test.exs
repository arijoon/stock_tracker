defmodule StockTrackerWeb.TargetWorkerTest do
  use StockTracker.DataCase

  alias StockTracker.TargetWorker
  alias StockTracker.Target

  test "Successfully calls the endpoint and stores the result" do
    detail = %Target{name: "hello", url: "http://example.com", delay_ms: 10000}

    {:ok, pid} = TargetWorker.start_link(detail)

    # Emulate a send
    :ok = Process.send(pid, {:lookup, self()}, [:noconnect])
    receive do
      :reply -> :na
    end

    records = StockTracker.Results.list_results()

    assert Enum.count(records) == 1
  end
end
