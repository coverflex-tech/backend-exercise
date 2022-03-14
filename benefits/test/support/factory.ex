defmodule Benefits.Factory do
  @moduledoc """
  Factories to be used in tests
  """

  alias Benefits.{Order, Product, Repo, User, Wallet}

  def build(:user) do
    %User{
      username: "John Doe"
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

  # Convenience API

  def build(factory_name, attributes) do
    factory_name |> build() |> struct!(attributes)
  end

  def insert!(factory_name, attributes \\ []) do
    factory_name |> build(attributes) |> Repo.insert!()
  end
end
