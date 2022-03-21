defmodule Backend.Repo.Migrations.CreateOrderItems do
  use Ecto.Migration

  def change do
    create table(:order_items, primary_key: false) do
      add :id, :binary_id, primary_key: true

      add :order_id, references(:orders, type: :uuid, column: :id), null: false
      add :product_id, references(:products, type: :string, column: :id), null: false
      timestamps()
    end
  end
end
