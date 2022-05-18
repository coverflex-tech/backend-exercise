defmodule Benefits.Repo.Migrations.CreateOrders do
  use Ecto.Migration

  def change do
    create table(:orders) do
      add :total, :decimal
      add :user_id, references("users", column: :user_id, type: :string), null: false

      timestamps()
    end

    create table(:orders_products) do
      add :order_id, references("orders"), null: false
      add :user_id, references("users", column: :user_id, type: :string), null: false
      add :product_id, references("products"), null: false

      timestamps()
    end

    create index(:orders_products, [:user_id, :product_id], unique: true)

    execute "CREATE EXTENSION btree_gist;"

    create constraint(:orders_products, :unique_user_id_per_order_id,
             exclude: ~s|gist (order_id with = , user_id with <>)|
           )
  end
end
