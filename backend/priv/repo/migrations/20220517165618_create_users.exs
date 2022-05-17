defmodule Benefits.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :username, :string
      add :balance, :decimal

      timestamps()
    end

    create index(:users, :username, unique: true)
  end
end
