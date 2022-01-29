defmodule Benefits.Repo.Migrations.AddTableOrdersProducts do
  use Ecto.Migration

  def change do
    create table(:orders_products, primary_key: false) do
      add(:order_id, references(:orders, on_delete: :delete_all), primary_key: true)
      add(:product_id, references(:products, on_delete: :delete_all), primary_key: true)
    end

    create(index(:orders_products, [:order_id]))
    create(index(:orders_products, [:product_id]))

    create(
      unique_index(:orders_products, [:order_id, :product_id],
        name: :order_id_product_id_unique_index
      )
    )
  end
end
