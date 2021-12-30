defmodule Coverflex.Benefits.Repo.Migrations.CreateProducts do
  use Ecto.Migration

  def change do
    create table(:products) do
      add :product_id, :string
      add :name, :string
      add :price, :integer

      timestamps()
    end

    create unique_index(:products, [:product_id])
  end
end
