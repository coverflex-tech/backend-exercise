defmodule Backend.Repo.Migrations.CreateOrders do
  use Ecto.Migration

  def change do
    create table(:orders) do
      add :total_value, :integer, null: false
      add :user_id, references(:users)

      timestamps()
    end
  end
end
