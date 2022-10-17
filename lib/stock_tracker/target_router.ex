defmodule StockTracker.TargetRouter do
  require Logger
  import HTTPoison, [:get]
  import StockTracker.Results, [:create_result]

  def route(%StockTracker.Target{} = target) do
    # Default invidia implementation
    handler =
      case target.url do
        "https://api.store.nvidia.com" <> _ ->
          &nvidia/1

        _ ->
          &default/1
      end

    handler.(target)

    :ok
  end

  def nvidia(%StockTracker.Target{} = target) do
    Logger.info("Nvidia matcher for #{inspect(target)}")

    headers = [
      Accept:
        "text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,*/*;q=0.8",
      "User-Agent":
        "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:107.0) Gecko/20100101 Firefox/107.0",
      Host: "api.store.nvidia.com",
      "Accept-Encoding": "gzip, deflate, br",
      "Accept-Language": "en-GB,en;q=0.5"
    ]

    case get(target.url, headers) do
      {:ok, %{body: body}} ->
        json = Jason.decode!(body)
        product = Enum.at(json["listMap"], 0)

        if product["is_active"] == "true" do
          result_found(product["product_url"], target.name, body)
        end

      {:error, detail} ->
        Logger.error("Failed to fetch API for #{target.name}, #{inspect(detail)}")
    end
  end

  def default(target) do
    Logger.emergency("No matcher for #{target.url}")
  end

  def result_found(message, name, payload) do
    # Store the result here
    create_result(%{
      name: name,
      message: message,
      payload: payload
    })

    alert_result(message, name)
  end

  def alert_result(message, name) do
    Phoenix.PubSub.broadcast(:app, "result", %{message: message, name: name})
  end

end
