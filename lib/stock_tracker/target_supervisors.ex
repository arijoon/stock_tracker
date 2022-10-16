defmodule StockTracker.TargetSupervisors do
  @moduledoc """
  Supervisor for the target lookup workers
  """
  use Supervisor

  import StockTracker.Target

  def start_link(opts) do
    Supervisor.start_link(__MODULE__, :ok, opts)
  end

  @impl true
  def init(:ok) do
    targets = Application.fetch_env!(:stock_tracker, :targets)

    children = targets
    |> Enum.map(fn target -> %{
      id: String.to_atom(target.name),
      start: {StockTracker.TargetWorker, :start_link, [struct!(StockTracker.Target, target)]}
    } end)

    Supervisor.init(children, strategy: :one_for_one)
  end
end
