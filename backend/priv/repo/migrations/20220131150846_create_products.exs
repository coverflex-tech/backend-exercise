defmodule Benefits.Repo.Migrations.CreateProducts do
  use Ecto.Migration

  def change do
    create table(:products) do
      add :identifier, :string, null: false
      add :name, :string, null: false
      add :price, :float, default: 0.00

      timestamps()
    end

    create unique_index(:products, [:identifier])
    create constraint(:products, :price_must_be_non_negative, check: "price >= 0.00")
  end
end
