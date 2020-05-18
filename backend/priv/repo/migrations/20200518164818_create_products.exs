defmodule CoverFlex.Repo.Migrations.CreateProducts do
  use Ecto.Migration

  def change do
    create table(:products, primary_key: false) do
      add :id, :string, primary_key: true
      add :name, :string
      add :price, :integer

      timestamps()
    end

  end
end
