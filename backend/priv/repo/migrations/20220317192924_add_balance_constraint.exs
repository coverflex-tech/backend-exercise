defmodule Benefits.Repo.Migrations.AddBalanceConstraint do
  use Ecto.Migration

  def up do
    create(
      constraint(
        :users,
        :balance_always_positive,
        check: "balance >= 0"
      )
    )
  end

  def down do
    drop(constraint(:users, :balance_always_positive))
  end
end
