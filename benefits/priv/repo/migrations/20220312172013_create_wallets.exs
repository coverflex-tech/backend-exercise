defmodule Benefits.Repo.Migrations.CreateWallets do
  use Ecto.Migration

  def change do
    create table("wallets") do
      add(:amount, :integer)
      add(:user_id, references(:users))

      timestamps()
    end

    create(unique_index("wallets", [:user_id]))
    create(constraint("wallets", :amount_must_be_non_negative, check: "amount >= 0"))
  end
end
