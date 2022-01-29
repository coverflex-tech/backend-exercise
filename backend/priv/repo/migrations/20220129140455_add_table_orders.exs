defmodule Benefits.Repo.Migrations.AddTableOrders do
  use Ecto.Migration

  def change do
    create table(:orders) do
      add(:user_id, references(:users))
      add(:total, :float, default: 0.00)
      timestamps()
    end
  end
end
