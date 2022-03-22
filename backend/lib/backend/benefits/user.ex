defmodule Backend.Benefits.User do
  use Ecto.Schema
  import Ecto.Changeset

  alias Backend.Benefits.Order

  schema "users" do
    field :balance, :integer
    field :username, :string

    has_many :orders, Order

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:username, :balance])
    |> validate_required([:username, :balance])
    |> validate_number(:balance, greater_than_or_equal_to: 0)
    |> unique_constraint(:username)
  end
end
