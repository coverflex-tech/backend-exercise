defmodule Backend.Repo.Migrations.CreateOrderedProducts do
  use Ecto.Migration

  def change do
    create table(:ordered_products) do
      add :order_id, references(:orders)
      add :product_id, references(:products)
    end

    create unique_index(:ordered_products, [:order_id, :product_id])
  end
end
