defmodule Coverflex.Accounts.UserAccount do
  use Ecto.Schema
  import Ecto.Changeset
  alias Coverflex.Repo

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "user_accounts" do
    field(:balance, :integer)
    belongs_to(:user, Coverflex.Accounts.User)

    timestamps()
  end

  @doc false
  def changeset(user_account, attrs) do
    user_account
    |> cast(attrs, [:balance, :user_id])
    |> validate_required([:balance])
    |> check_constraint(:balance,
      name: :balance_must_be_greater_than_or_equal_zero,
      message: "balance must be greater than or equal zero"
    )
  end

  @doc false
  def update_changeset(user_account, attrs) do
    user_account
    |> cast(attrs, [:balance])
    |> validate_required([:balance])
    |> check_constraint(:balance,
      name: :balance_must_be_greater_than_or_equal_zero,
      message: "balance must be greater than or equal zero"
    )
  end
end
