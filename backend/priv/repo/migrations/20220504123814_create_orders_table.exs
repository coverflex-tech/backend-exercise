defmodule Backend.Repo.Migrations.CreateOrdersTable do
  use Ecto.Migration

  import Ecto.SoftDelete.Migration

  def change do
    create table(:orders) do
      add :total_amount, :decimal
      add :user_id, references(:users, type: :string, column: :username)

      timestamps()
      soft_delete_columns()
    end
  end
end
