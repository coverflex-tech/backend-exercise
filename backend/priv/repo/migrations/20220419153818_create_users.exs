defmodule Backend.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users, primary_id: false) do
      add :user_id, :string, primary_key: true
      add :balance, :integer, default: 500

      timestamps()
    end
  end
end
