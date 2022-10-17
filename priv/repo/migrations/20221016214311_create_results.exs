defmodule StockTracker.Repo.Migrations.CreateResults do
  use Ecto.Migration

  def change do
    create table(:results) do
      add :name, :string
      add :payload, :text
      add :message, :text

      timestamps()
    end

    create index(:results, [:inserted_at])
  end
end
