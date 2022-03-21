defmodule Backend.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users, primary_key: false) do
      add :id, :string, primary_key: true
      add :balance, :decimal

      timestamps()
    end

    create constraint(:users, :balance_must_be_positive_or_zero, check: "balance >= 0")
  end
end
