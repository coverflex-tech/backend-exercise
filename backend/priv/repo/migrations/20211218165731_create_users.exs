defmodule Benefits.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table :users do
      add :user_id, :string
      add :balance, :float

      timestamps()
    end

    create unique_index(:users, [:user_id])
  end
end
