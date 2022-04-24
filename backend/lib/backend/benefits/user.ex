defmodule Backend.Benefits.User do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:user_id, :string, autogenerate: false}
  schema "users" do
    field :balance, :integer, default: 50000
    has_many :orders, Backend.Benefits.Order, foreign_key: :user_id

    many_to_many :products, Backend.Benefits.Product,
      join_through: Backend.Benefits.Benefit,
      join_keys: [user_id: :user_id, product_id: :id],
      unique: true

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:user_id, :balance])
    |> validate_required([:user_id, :balance])
    |> unique_constraint(:user_id)
  end
end
