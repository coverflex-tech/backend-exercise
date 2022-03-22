defmodule BenefitsAPI.OrdersControllerTest do
  use BenefitsAPI.ConnCase

  alias Benefits.Repo

  describe "/api/orders" do
    setup do
      user = insert!(:user)

      products =
        for _ <- 1..2 do
          insert!(:product, price: 1000)
        end

      total_price = Enum.reduce(products, 0, &(&1.price + &2))

      {:ok, products: products, user: user, total_price: total_price}
    end

    test "returns 201 when creates the new order successfully", ctx do
      path = Routes.orders_path(@endpoint, :create)
      insert!(:wallet, user_id: ctx.user.id, amount: ctx.total_price)

      params = %{
        "order" => %{
          "user_id" => ctx.user.username,
          "items" => Enum.map(ctx.products, & &1.id)
        }
      }

      assert %{
               "order" => %{
                 "order_id" => _,
                 "data" => %{
                   "items" => [_ | _],
                   "total" => _
                 }
               }
             } =
               ctx.conn
               |> post(path, params)
               |> json_response(201)
    end

    test "returns 400 if the balance is insufficient", ctx do
      path = Routes.orders_path(@endpoint, :create)
      insert!(:wallet, user_id: ctx.user.id, amount: ctx.total_price - 1)

      params = %{
        "order" => %{
          "user_id" => ctx.user.username,
          "items" => Enum.map(ctx.products, & &1.id)
        }
      }

      assert %{
               "error" => "insufficient_balance"
             } ==
               ctx.conn
               |> post(path, params)
               |> json_response(400)
    end

    test "returns 400 if the product was already purchased", ctx do
      path = Routes.orders_path(@endpoint, :create)
      insert!(:wallet, user_id: ctx.user.id, amount: ctx.total_price)
      order = insert!(:order, user_id: ctx.user.id)
      insert!(:order_product, order_id: order.id, product_id: List.first(ctx.products).id)

      params = %{
        "order" => %{
          "user_id" => ctx.user.username,
          "items" => Enum.map(ctx.products, & &1.id)
        }
      }

      assert %{
               "error" => "products_already_purchased"
             } ==
               ctx.conn
               |> post(path, params)
               |> json_response(400)
    end

    test "returns 400 some product is not found", ctx do
      path = Routes.orders_path(@endpoint, :create)
      insert!(:wallet, user_id: ctx.user.id, amount: ctx.total_price)

      for p <- ctx.products, do: Repo.delete(p)

      params = %{
        "order" => %{
          "user_id" => ctx.user.username,
          "items" => [1]
        }
      }

      assert %{
               "error" => "products_not_found"
             } ==
               ctx.conn
               |> post(path, params)
               |> json_response(400)
    end
  end
end
