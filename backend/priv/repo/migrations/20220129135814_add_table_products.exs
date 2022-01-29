defmodule Benefits.Repo.Migrations.AddTableProducts do
  use Ecto.Migration

  def change do
    create table(:products) do
      add(:identifier, :string)
      add(:name, :string, default: "")
      add(:price, :float, default: 0.00)
      timestamps()
    end

    create unique_index(:products, [:identifier])
  end
end
