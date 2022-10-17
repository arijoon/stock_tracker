defmodule StockTracker.Results.Result do
  use Ecto.Schema
  import Ecto.Changeset

  schema "results" do
    field :message, :string
    field :name, :string
    field :payload, :string

    timestamps()
  end

  @doc false
  def changeset(result, attrs) do
    result
    |> cast(attrs, [:name, :payload, :message])
    |> validate_required([:name, :payload, :message])
  end
end
