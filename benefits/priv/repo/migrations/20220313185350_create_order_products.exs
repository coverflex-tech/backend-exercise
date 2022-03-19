defmodule Benefits.Repo.Migrations.CreateOrderProducts do
  use Ecto.Migration

  def change do
    create table("order_products", primary_key: false) do
      add(:order_id, references(:orders), primary_key: true)
      add(:product_id, references(:products), primary_key: true)
    end

    create(index("order_products", [:order_id]))
  end
end
