defmodule Backend.Repo.Migrations.CreateOrderedProducts do
  use Ecto.Migration

  def change do
    create table(:ordered_products) do
      add :order_id, references(:orders)
      add :product_id, references(:products)
      add :user_id, references(:users)
    end

    create unique_index(:ordered_products, [:order_id, :product_id])
    create unique_index(:ordered_products, [:product_id, :user_id])
  end
end
