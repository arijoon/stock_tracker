defmodule StockTrackerWeb.PageController do
  use StockTrackerWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
