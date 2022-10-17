defmodule StockTracker.TargetWorker do
  use GenServer
  require Logger

  @impl true
  def init(%StockTracker.Target{} = detail) do
    loop(detail.delay_ms)

    {:ok, detail}
  end

  def loop(delay) do
    Process.send_after(self(), {:lookup, self()}, delay)
  end

  @impl true
  def handle_info({:lookup, sender}, detail) do
    Logger.info("Received lookup request, with current state #{inspect detail}")

    StockTracker.TargetRouter.route(detail)

    loop(detail.delay_ms)

    Process.send(sender, :reply, [])

    {:noreply, detail}
  end

  def handle_info(:reply, _) do
    # Do nothing
  end

  # API
  @doc """
  Starts the Worker
  """
  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts)
  end

  def lookup(pid) do
    GenServer.call(pid, :lookup)
  end
end
