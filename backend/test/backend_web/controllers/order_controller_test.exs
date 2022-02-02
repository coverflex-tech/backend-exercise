defmodule BackendWeb.OrderControllerTest do
  use BackendWeb.ConnCase

  import Backend.{ProductsFixtures, UsersFixtures}

  setup %{conn: conn} do
    user = user_fixture(%{user_id: "user-order-test-#{Enum.random(1..1000)}", balance: 600})
    products = [product_fixture(%{price: 300}), product_fixture(%{price: 300})]
    products_ids = Enum.map(products, fn p -> p.id end)

    {:ok,
     conn: put_req_header(conn, "accept", "application/json"),
     user: user,
     products: products,
     products_ids: products_ids}
  end

  describe "create order" do
    test "renders order when data is valid", %{
      conn: conn,
      user: user,
      products_ids: products_ids
    } do
      conn = post(conn, Routes.order_path(conn, :create), order_struct(user, products_ids))

      assert %{"order_id" => _id, "data" => %{"items" => _, "total" => _}} =
               json_response(conn, 200)["order"]
    end

    test "renders bad request with products already purchased message", %{
      conn: conn,
      user: user,
      products_ids: products_ids
    } do
      conn = post(conn, Routes.order_path(conn, :create), order_struct(user, products_ids))

      assert %{"order_id" => _id, "data" => %{"items" => _, "total" => _}} =
               json_response(conn, 200)["order"]

      conn = post(conn, Routes.order_path(conn, :create), order_struct(user, products_ids))
      assert %{"error" => "products_already_purchased"} = json_response(conn, 400)
    end

    test "renders bad request with insufficient balance message", %{
      conn: conn,
      user: user
    } do
      products = [product_fixture(%{price: 300}), product_fixture(%{price: 301})]
      products_ids = Enum.map(products, fn p -> p.id end)
      conn = post(conn, Routes.order_path(conn, :create), order_struct(user, products_ids))

      assert %{"error" => "insufficient_balance"} = json_response(conn, 400)
    end

    test "renders bad request with products not found message", %{
      conn: conn,
      user: user
    } do
      products_ids = ["inexistent-product-1", "inexistent-product-2"]
      conn = post(conn, Routes.order_path(conn, :create), order_struct(user, products_ids))

      assert %{"error" => "products_not_found"} = json_response(conn, 400)
    end
  end

  defp order_struct(user, products_ids) do
    %{
      order: %{
        items: products_ids,
        user_id: user.user_id
      }
    }
  end
end
