defmodule Backend.Users.User do
  use Ecto.Schema

  import Ecto.SoftDelete.Schema

  alias Backend.Orders.Order

  @primary_key {:username, :string, autogenerate: false}

  schema "users" do
    field :balance, :decimal, default: Decimal.new(0)

    has_many :orders, Order, foreign_key: :user_id

    timestamps()
    soft_delete_schema()
  end
end
