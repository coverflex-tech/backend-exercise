defmodule Benefits.Factory do
  use ExMachina.Ecto, repo: Benefits.Repo

  alias Benefits.Orders.Order
  alias Benefits.Products.Product
  alias Benefits.Users.User

  def user_factory do
    %User{
      username: Faker.Pokemon.name(),
      balance: 20_000,
      inserted_at: NaiveDateTime.utc_now(),
      updated_at: NaiveDateTime.utc_now()
    }
  end

  def product_factory do
    %Product{
      id: Ecto.UUID.autogenerate(),
      name: Faker.Vehicle.model(),
      price: 5_000,
      inserted_at: NaiveDateTime.utc_now(),
      updated_at: NaiveDateTime.utc_now()
    }
  end

  def order_factory do
    products = Enum.map(1..3, fn _n -> struct!(product_factory()) end)

    %Order{
      id: Ecto.UUID.autogenerate(),
      user_id: Faker.Pokemon.name(),
      products: products,
      total_price: Enum.reduce(products, 0, &(&1.price + &2))
    }
  end
end
