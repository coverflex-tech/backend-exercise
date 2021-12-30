defmodule Coverflex.Benefits.Repo.Migrations.CreateVallets do
  use Ecto.Migration

  def change do
    create table(:vallets) do
      add :balance, :integer
      add :user_id, references(:users, on_delete: :nothing)

      timestamps()
    end

    create index(:vallets, [:user_id])
  end
end
