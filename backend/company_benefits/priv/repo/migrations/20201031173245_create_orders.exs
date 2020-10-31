defmodule CompanyBenefits.Repo.Migrations.CreateOrders do
  use Ecto.Migration

  def change do
    create table(:orders) do
      add(
        :user_id,
        references(:users, on_delete: :delete_all),
        null: false
      )

      add(:total, :float, null: false)

      timestamps()
    end

    create table(:orders_products) do
      add(:order_id, references(:orders, on_delete: :delete_all))
      add(:product_id, references(:products, on_delete: :delete_all))

      timestamps()
    end

    create(unique_index(:orders_products, [:order_id, :product_id]))
  end
end
