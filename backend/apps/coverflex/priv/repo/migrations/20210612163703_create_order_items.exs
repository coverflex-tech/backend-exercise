defmodule Coverflex.Repo.Migrations.CreateOrderItems do
  use Ecto.Migration

  def change do
    create table(:order_items, primary_key: false) do
      add(:id, :binary_id, primary_key: true)
      add(:order_id, references(:orders, on_delete: :nothing, type: :uuid), null: false)
      add(:product_id, references(:products, on_delete: :nothing, type: :uuid), null: false)
      add(:price, :integer, null: false)

      timestamps()
    end

    create(index(:order_items, [:order_id]))
    create(index(:order_items, [:product_id]))
  end
end
