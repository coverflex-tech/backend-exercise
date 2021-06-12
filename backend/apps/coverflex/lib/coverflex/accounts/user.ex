defmodule Coverflex.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "users" do
    field(:user_id, :string)
    has_many(:orders, Coverflex.Orders.Order)

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:user_id])
    |> validate_required([:user_id])
    |> unique_constraint([:user_id], name: :user_id_unique_index)
  end
end
