defmodule Backend.Repo.Migrations.CreateOrders do
  use Ecto.Migration

  def change do
    create table(:orders, primary_key: false) do
      add(:order_id, :serial)
      add(:items, {:array, :string})
      add(:total, :integer)

      add(:user_id, references("users", column: :user_id, on_delete: :nilify_all, type: :string))

      timestamps()
    end

    create(unique_index(:orders, [:order_id]))
  end
end
