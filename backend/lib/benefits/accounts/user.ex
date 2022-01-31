defmodule Benefits.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, Ecto.UUID, autogenerate: true}

  schema "users" do
    field :user_id, :string
    field :balance, :float, default: 0.00

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:user_id, :balance])
    |> validate_required([:user_id])
    |> unique_constraint(:user_id)
    |> check_constraint(:balance,
      name: :balance_must_be_non_negative,
      message: "Balance must be non-negative"
    )
  end
end
