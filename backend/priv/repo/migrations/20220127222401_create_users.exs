defmodule Backend.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users, primary_key: false) do
      add(:user_id, :string)
      add(:balance, :integer)

      timestamps()
    end
  end
end
