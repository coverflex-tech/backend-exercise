defmodule CoverFlex.Repo.Migrations.CreateProductsOrders do
  use Ecto.Migration

  def change do
    create table(:products_orders, primary_key: false) do
      add :product_id, references(:products, type: :string, on_delete: :delete_all), null: false
      add :order_id, references(:orders, on_delete: :delete_all), null: false
    end
  end
end
