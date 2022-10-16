defmodule StockTrackerWeb.TargetWorkerTest do
  use StockTracker.DataCase

  alias StockTracker.TargetWorker
  alias StockTracker.Target

  test "Starts process successfully" do
    detail = %Target{name: "hello", url: "example.com", delay_ms: 500}

    pid = TargetWorker.start_link(detail)
  end
end
