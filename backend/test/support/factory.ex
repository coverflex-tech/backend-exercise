defmodule Benefits.Factory do
  @moduledoc false
  use ExMachina.Ecto, repo: Benefits.Repo

  alias Benefits.Order
  alias Benefits.Product
  alias Benefits.User

  def user_factory do
    %User{
      username: sequence(:username, &"CoverflexUser#{&1}"),
      balance: 10.0
    }
  end

  def product_factory do
    seq = sequence(:identifier, &"#{&1}")

    %Product{
      identifier: "product_#{seq}",
      name: "Product #{seq}",
      price: 10.0
    }
  end

  def order_factory do
    products = build_list(5, :product)

    %Order{
      user_id: build(:user).id,
      total: products |> Enum.map(& &1.price) |> Enum.sum(),
      products: products
    }
  end
end
