defmodule StockTracker.Repo do
  use Ecto.Repo,
    otp_app: :stock_tracker,
    adapter: Ecto.Adapters.Postgres
end
