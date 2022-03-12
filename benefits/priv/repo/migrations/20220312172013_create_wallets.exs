defmodule Benefits.Repo.Migrations.CreateWallets do
  use Ecto.Migration

  def change do
    create table("wallets", primary_key: false) do
      add(:id, :uuid, primary_key: true)
      add(:amount, :integer)
      add(:user_id, references(:users, type: :uuid))

      timestamps()
    end

    create(unique_index("wallets", [:user_id]))
    create(constraint("wallets", :amount_must_be_non_negative, check: "amount >= 0"))
  end
end
