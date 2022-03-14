defmodule Benefits.Repo.Migrations.CreateOrderProducts do
  use Ecto.Migration

  def change do
    create table("order_products", primary_key: false) do
      add(:order_id, references(:orders, type: :uuid), primary_key: true)
      add(:product_id, references(:products, type: :uuid), primary_key: true)
    end

    create(index("order_products", [:order_id]))
    create(index("order_products", [:product_id]))
  end
end
