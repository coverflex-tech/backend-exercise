defmodule CompanyBenefits.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add(:username, :string, null: false)
      add(:balance, :float, null: false, default: 0)

      timestamps()
    end

    create(unique_index(:users, [:username]))
  end
end
