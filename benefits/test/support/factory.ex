defmodule Benefits.Factory do
  @moduledoc """
  Factories to be used in tests
  """

  alias Benefits.{Repo, User, Wallet, Order, OrderProduct, Product, CreateOrder}

  def build(:user) do
    %User{
      username: "John Doe #{Ecto.UUID.generate()}"
    }
  end

  def build(:wallet) do
    %Wallet{user_id: build(:user).id, amount: Money.new(5000)}
  end

  def build(:product) do
    %Product{name: "Netflix", price: Money.new(2000)}
  end

  def build(:order) do
    %Order{user_id: build(:user).id, price: Money.new(5000), products: [build(:product)]}
  end

  def build(:order_product) do
    %OrderProduct{order_id: build(:order).id, product_id: build(:product).id}
  end

  def build(:create_order_input) do
    %CreateOrder{user_id: build(:user).id, items: [build(:product).id]}
  end

  # Convenience API

  def build(factory_name, attributes) do
    factory_name |> build() |> struct!(attributes)
  end

  def insert!(factory_name, attributes \\ []) do
    factory_name |> build(attributes) |> Repo.insert!()
  end
end
