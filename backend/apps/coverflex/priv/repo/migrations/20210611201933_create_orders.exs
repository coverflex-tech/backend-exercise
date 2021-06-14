defmodule Coverflex.Repo.Migrations.CreateOrders do
  use Ecto.Migration

  def change do
    create table(:orders, primary_key: false) do
      add(:id, :binary_id, primary_key: true)
      add(:total, :integer, default: 0)
      add(:user_id, references(:users, on_delete: :nothing, type: :uuid), null: false)

      timestamps()
    end

    create(constraint(:orders, :total_must_be_greater_than_or_equal_zero, check: "total >= 0"))
    create(index(:orders, [:user_id]))
  end
end
