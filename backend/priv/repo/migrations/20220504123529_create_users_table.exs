defmodule Backend.Repo.Migrations.CreateUsersTable do
  use Ecto.Migration

  import Ecto.SoftDelete.Migration

  def change do
    create table(:users, primary_key: false) do
      add :username, :string, primary_key: true
      add :balance, :decimal, null: false

      timestamps()
      soft_delete_columns()
    end
  end
end
