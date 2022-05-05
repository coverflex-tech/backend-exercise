defmodule Backend.Orders.Order do
  use Ecto.Schema

  import Ecto.SoftDelete.Schema

  alias Backend.Products.Product
  alias Backend.Users.User

  schema "orders" do
    field :total_amount, :decimal, default: Decimal.new(0)

    belongs_to :user, User, references: :username, type: :string

    has_many :products, Product

    timestamps()
    soft_delete_schema()
  end
end
