defmodule StockTracker.NotifierWorker do
  use GenServer
  require Logger

  @impl true
  def init(:ok) do
    Phoenix.PubSub.subscribe(:app, "result")
    {:ok, {}}
  end

  @impl true
  def handle_info(%{message: message, name: name}, state) do
    Logger.info("Received Notification request for #{name}")

    {:ok, _} =
      HTTPoison.post(
        Application.fetch_env!(:stock_tracker, :notification_address),
        Jason.encode!(%{
          message: """
          #{name} is Available
          ================================================================================
          #{message}
          """
        }),
        [{"Content-Type", "application/json"}]
      )

    {:noreply, state}
  end

  def handle_info(_, state) do
    {:noreply, state}
  end

  # API
  @doc """
  Starts the Worker
  """
  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts)
  end
end
