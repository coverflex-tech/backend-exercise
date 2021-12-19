defmodule Benefits.Repo.Migrations.CreateOrdersProducts do
  use Ecto.Migration

  def change do
    create table(:orders_products) do
      add :order_id, references(:orders)
      add :product_id, references(:products)
    end

    create unique_index(:orders_products, [:order_id, :product_id])
  end
end
