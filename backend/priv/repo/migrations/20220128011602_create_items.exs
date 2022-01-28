defmodule Backend.Repo.Migrations.CreateItems do
  use Ecto.Migration

  def change do
    create table(:items) do
      add(:price, :integer)
      add(:order_id, references(:orders, on_delete: :nothing))
      add(:user_id, references(:users, column: :user_id, type: :string, on_delete: :nothing))
      add(:product_id, references(:products, column: :id, type: :string, on_delete: :nothing))

      timestamps()
    end

    create(index(:items, [:order_id]))
    create(index(:items, [:user_id]))
    # create(index(:items, [:product_id]))
    create(unique_index(:items, [:user_id, :product_id]))
  end
end
