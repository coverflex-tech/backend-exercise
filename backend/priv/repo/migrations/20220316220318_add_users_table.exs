defmodule Benefits.Repo.Migrations.AddUsersTable do
  use Ecto.Migration

  def up do
    create table("users") do
      add :username, :string, primary_key: true
      add :balance, :integer, null: false, default: 20000

      timestamps()
    end

    create unique_index(:users, :username)
  end

  def down do
    drop table("users")
  end
end
