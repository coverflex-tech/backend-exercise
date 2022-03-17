defmodule Benefits.Orders.CommandsTest do
  use Benefits.DataCase, async: true

  import Benefits.Factory

  alias Benefits.Orders.Commands

  describe "create_order/1" do
    setup do
      user = insert(:user)
      products = insert_list(3, :product)
      %{user: user, products: products}
    end

    test "it creates an order with the given products and username", ctx do
      items = Enum.map(ctx.products, & &1.id)
      user_id = ctx.user.username

      assert {:ok, order} = Commands.create_order(%{items: items, user_id: user_id})
      assert order.user_id == user_id
      assert Enum.map(order.products, & &1.id) == items
    end

    test "fails to create when products can't be found", ctx do
      items = Enum.map(1..3, fn _x -> Ecto.UUID.autogenerate() end)
      user_id = ctx.user.username

      assert {:error, :products_not_found} =
               Commands.create_order(%{items: items, user_id: user_id})
    end

    test "fails to create when user can't be found", ctx do
      items = Enum.map(ctx.products, & &1.id)
      user_id = "redrum"

      assert {:error, :user_not_found} = Commands.create_order(%{items: items, user_id: user_id})
    end

    test "fails to create when products have already been purchased", ctx do
      products = Enum.map(ctx.products, &Map.drop(&1, [:__meta__]))
      insert(:order, products: products, user_id: ctx.user.username)

      items = Enum.map(ctx.products, & &1.id)
      user_id = ctx.user.username

      assert {:error, :products_already_purchased} =
               Commands.create_order(%{items: items, user_id: user_id})
    end

    test "fails to create when user does not have enough balance", ctx do
      %{username: user_id} = insert(:user, balance: 0)
      items = Enum.map(ctx.products, & &1.id)

      assert {:error, :insufficient_balance} =
               Commands.create_order(%{items: items, user_id: user_id})
    end
  end
end
