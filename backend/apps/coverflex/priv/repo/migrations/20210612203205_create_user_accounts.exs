defmodule Coverflex.Repo.Migrations.CreateUserAccounts do
  use Ecto.Migration

  def change do
    create table(:user_accounts, primary_key: false) do
      add(:id, :binary_id, primary_key: true)
      add(:balance, :integer, default: 0)
      add(:user_id, references(:users, on_delete: :nothing, type: :uuid), null: false)

      timestamps()
    end

    create(
      constraint(:user_accounts, :balance_must_be_greater_than_or_equal_zero,
        check: "balance >= 0"
      )
    )

    create(unique_index(:user_accounts, [:user_id]))
  end
end
