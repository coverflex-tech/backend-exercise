defmodule Benefits.Perks.OrderLine do
  use Ecto.Schema
  import Ecto.Changeset

  alias Benefits.Accounts.User
  alias Benefits.Perks.{Order, Product}

  @primary_key {:id, Ecto.UUID, autogenerate: true}

  schema "order_lines" do
    belongs_to :user, User, foreign_key: :user_id, type: :binary_id
    belongs_to :order, Order, foreign_key: :order_id, type: :binary_id
    belongs_to :product, Product, foreign_key: :product_id, type: :id

    timestamps()
  end

  @doc false
  def changeset(%__MODULE__{} = order_line, attrs) do
    order_line
    |> cast(attrs, [:user_id, :order_id, :product_id])
    |> validate_required([:user_id, :order_id, :product_id])
    |> unique_constraint(:order_id, name: :unique_line_index)
    |> unique_constraint(:user_id,
      name: :one_product_per_user_index,
      message: "products_already_purchased"
    )
  end
end
