defmodule Backend.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :user_id, :string
      add :balance, :integer

      timestamps()
    end

    create unique_index(:users, [:user_id])
  end
end
