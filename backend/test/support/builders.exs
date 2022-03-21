defmodule Builders do
  defmacro __using__(_options) do
    quote do
      def create_user(opts \\ []) do
        params = Enum.into(opts, %{id: "frodo", balance: Decimal.new("100.00")})
        Backend.Domain.Repositories.Users.create(params)
      end

      def create_order(opts \\ []) do
        params = Enum.into(opts, %{user_id: "frodo", total: Decimal.new("10.00")})
        Backend.Domain.Repositories.Orders.create(params)
      end

      def create_product(opts \\ []) do
        params = Enum.into(opts, %{id: "netflix", name: "Netflix", price: Decimal.new("10.00")})
        Backend.Domain.Repositories.Products.create(params)
      end
    end
  end
end
