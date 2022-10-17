defmodule StockTracker.TargetRouter do
  require Logger
  # import HTTPoison, [:get]
  import StockTracker.Results, [:create_result]

  def route(%StockTracker.Target{} = target) do
    # Default invidia implementation
    handler =
      case target.url do
        "http://example.com" <> _ ->
          &nvidia/1

        _ ->
          &default/1
      end

    handler.(target)

    :ok
  end

  def nvidia(%StockTracker.Target{} = target) do
    Logger.info("Nvidia matcher for #{inspect(target)}")

    case get(target.url) do
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
    Phoenix.PubSub.broadcast(:app, "result", %{ message: message, name: name })
  end

  def get(_) do
    {:ok,
     %{
       status_code: 200,
       body: """
       {"success":true,"map":null,"listMap":[{"is_active":"true","product_url":"https://www.scan.co.uk/nvidia/pr/3080ti?t\u003dkDpiSmuOPcUYq9wuiw23Xqfm4tdY19sBSxxMa1r1uUSZBjWzCqmCupNyM7hGPHyfketrwQiSGrecZXtzrFlOY1VjQmA6hoR6YCx4cH3m5y%2FEhxGTbayK32fR0ClHSTqyp3wPUslxtTdpeIimS2gQfUmBwuQY%2BX0RH%2FiBW84JeCiM7b3vXRxcbNpHX3%2B6O89rxVuG492fxrsKJ4S1HkSUHtrc1pmj9GEXNbZ8uF578TVHYYiEsFtsTpMRmr3qJnM4iPNSGcDVKeMISVNtgPQHjSwdGndaOOl3L04s%2FN3PnvAk0ob87RKdbJR3bMCv2Fb1NyPvMTijwoGxiIXRqPz5kA%3D%3D","price":"929.004","fe_sku":"NVGFT080T_UK","locale":"UK"}]}
       """
     }}
  end
end
