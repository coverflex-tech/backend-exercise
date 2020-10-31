defmodule CompanyBenefits.Repo.Migrations.CreateProducts do
  use Ecto.Migration

  def change do
    create table(:products) do
      add(:identifier, :string, null: false)
      add(:name, :string, null: false)
      add(:price, :float, null: false, default: 0)

      timestamps()
    end

    create(unique_index(:products, [:identifier]))
  end
end
