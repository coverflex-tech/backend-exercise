defmodule Backend.Repo.Migrations.CreateOrders do
  use Ecto.Migration

  def change do
    create table(:orders) do
      add(:total, :integer)
      add(:user_id, references(:users, column: :user_id, type: :string, on_delete: :nothing))

      timestamps()
    end

    create(index(:orders, [:user_id]))
  end
end
