defmodule Builders do
  defmacro __using__(_options) do
    quote do
      def create_user(opts \\ []) do
        params = Enum.into(opts, %{id: "frodo", balance: Decimal.new("100.00")})

        %Backend.Users.Schemas.User{}
        |> Backend.Users.Schemas.User.changeset(params)
        |> Backend.Repo.insert()
      end

      def create_order(opts \\ []) do
        params = Enum.into(opts, %{user_id: "frodo", total: Decimal.new("10.00")})

        %Backend.Orders.Schemas.Order{}
        |> Backend.Orders.Schemas.Order.changeset(params)
        |> Backend.Repo.insert()
      end

      def create_product(opts \\ []) do
        params = Enum.into(opts, %{id: "netflix", name: "Netflix", price: Decimal.new("10.00")})
        %Backend.Products.Schemas.Product{}
        |> Backend.Products.Schemas.Product.changeset(params)
        |> Backend.Repo.insert()
      end
    end
  end
end
