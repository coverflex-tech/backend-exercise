defmodule Benefits.Repo.Migrations.AddTableUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add(:username, :string)
      add(:balance, :float, default: 0.00)
      timestamps()
    end

    create unique_index(:users, [:username])
  end
end
