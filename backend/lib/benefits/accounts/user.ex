defmodule Benefits.Accounts.User do
  @moduledoc """
  User struct and schema to persist in the data store.
  """

  use Ecto.Schema
  import Ecto.Changeset

  alias Benefits.Perks.{Order, OrderLine, Product}

  @primary_key {:id, Ecto.UUID, autogenerate: true}

  schema "users" do
    field :user_id, :string
    field :balance, :float, default: 0.00

    many_to_many :products, Product, join_through: OrderLine
    many_to_many :orders, Order, join_through: OrderLine

    timestamps()
  end

  @doc false
  def changeset(%__MODULE__{} = user, attrs) do
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
