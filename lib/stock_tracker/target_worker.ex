defmodule StockTracker.TargetWorker do
  use GenServer
  require Logger

  @impl true
  def init(%StockTracker.Target{} = detail) do
    loop(detail.delay_ms)

    {:ok, detail}
  end

  def loop(delay) do
    Process.send_after(self(), :lookup, delay)
  end

  @impl true
  def handle_info(:lookup, detail) do
    Logger.info("Received lookup request, with current state #{inspect detail}")
    # Switch to find the implementation for the detail
    loop(detail.delay_ms)
    {:noreply, detail}
  end

  # API
  @doc """
  Starts the Worker
  """
  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts)
  end
end
