defmodule Benefits.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users, primary_key: false) do
      add :id, :uuid, primary_key: true, null: false

      add :user_id, :string
      add :balance, :float, default: 0.00

      timestamps()
    end

    create unique_index(:users, [:user_id])
    create constraint(:users, :balance_must_be_positive, check: "balance >= 0.00")
  end
end
