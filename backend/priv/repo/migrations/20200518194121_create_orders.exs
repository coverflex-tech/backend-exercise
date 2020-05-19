defmodule CoverFlex.Repo.Migrations.CreateOrders do
  use Ecto.Migration

  def change do
    create table(:orders) do
      add :total, :integer
      add :user_id, references(:users, type: :string, on_delete: :delete_all), null: false

      timestamps()
    end

    create index(:orders, [:user_id])
  end
end
