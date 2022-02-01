defmodule Benefits.Repo.Migrations.CreateOrderLines do
  use Ecto.Migration

  def change do
    create table(:order_lines, primary_key: false) do
      add :id, :uuid, primary_key: true, null: false

      add :user_id, references(:users, type: :uuid, on_delete: :delete_all)
      add :order_id, references(:orders, type: :uuid, on_delete: :delete_all)
      add :product_id, references(:products, on_delete: :delete_all)

      timestamps()
    end

    create unique_index(:order_lines, [:user_id, :order_id, :product_id], name: :unique_line_index)

    create unique_index(:order_lines, [:user_id, :product_id], name: :one_product_per_user_index)
  end
end
