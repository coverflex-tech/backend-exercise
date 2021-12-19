defmodule Benefits.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table :users do
      add :username, :string
      add :balance, :float

      timestamps()
    end

    create unique_index :users, [:username]
  end
end
