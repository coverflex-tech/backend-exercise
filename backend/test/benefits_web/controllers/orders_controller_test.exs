defmodule BenefitsWeb.OrdersControllerTest do
  use BenefitsWeb.ConnCase, async: true

  import Benefits.Factory

  alias Benefits.Orders.Order
  alias Benefits.Repo

  describe "create/2" do
    setup do
      user = insert(:user)
      products = insert_list(3, :product)
      %{user: user, products: products}
    end

    test "returns 200 with created order details", ctx do
      product_ids = Enum.map(ctx.products, & &1.id)

      create_params = %{
        "order" => %{
          "items" => product_ids,
          "user_id" => ctx.user.username
        }
      }

      assert result =
               ctx.conn
               |> post("/api/orders", create_params)
               |> json_response(200)

      assert [order] = Repo.all(Order)

      filtered_products =
        order.products
        |> Enum.map(&%{"id" => &1.id, "name" => &1.name, "price" => &1.price})

      assert result == %{
               "order" => %{
                 "data" => %{
                   "items" => filtered_products,
                   "total" => order.total_price
                 },
                 "order_id" => order.id
               }
             }
    end

    test "returns 400 and `user_not_found` when user does not exist", ctx do
      product_ids = Enum.map(ctx.products, & &1.id)

      create_params = %{
        "order" => %{
          "items" => product_ids,
          "user_id" => "redrum"
        }
      }

      assert %{"reason" => "user_not_found"} ==
               ctx.conn
               |> post("/api/orders", create_params)
               |> json_response(400)
    end

    test "returns 400 and `insufficient_balance` when user" <>
           " does not have enough balance",
         ctx do
      user = insert(:user, balance: 0)
      product_ids = Enum.map(ctx.products, & &1.id)

      create_params = %{
        "order" => %{
          "items" => product_ids,
          "user_id" => user.username
        }
      }

      assert %{"reason" => "insufficient_balance"} ==
               ctx.conn
               |> post("/api/orders", create_params)
               |> json_response(400)
    end

    test "returns 400 and `products_not_found` when products" <>
           " can't be found",
         ctx do
      create_params = %{
        "order" => %{
          "items" => [Ecto.UUID.autogenerate()],
          "user_id" => ctx.user.username
        }
      }

      assert %{"reason" => "products_not_found"} ==
               ctx.conn
               |> post("/api/orders", create_params)
               |> json_response(400)
    end

    test "returns 400 and `products_already_purchased` when products" <>
           " have already been purchased",
         ctx do
      products = Enum.map(ctx.products, &Map.drop(&1, [:__meta__]))
      insert(:order, user_id: ctx.user.username, products: products)

      product_ids = Enum.map(ctx.products, & &1.id)

      create_params = %{
        "order" => %{
          "items" => product_ids,
          "user_id" => ctx.user.username
        }
      }

      assert %{"reason" => "products_already_purchased"} ==
               ctx.conn
               |> post("/api/orders", create_params)
               |> json_response(400)
    end
  end
end
