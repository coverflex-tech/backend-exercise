defmodule BackendWeb.OrdersControllerTest do
  use BackendWeb.ConnCase, async: true
  alias Backend.{Product, User, Repo}

  describe "create order" do
    test "returns 200 status code with the created order", %{conn: conn} do
      Repo.insert!(%Product{id: "product_a", name: "Product A", price: 10})
      Repo.insert!(%Product{id: "product_b", name: "Product B", price: 20})

      conn =
        post(conn, "/api/orders", %{
          "order" => %{"user_id" => "user_id", "items" => ["product_a", "product_b"]}
        })

      assert %{
               "order" => %{
                 "order_id" => order_id,
                 "data" => %{
                   "user_id" => "user_id",
                   "total" => 30,
                   "items" => ["product_a", "product_b"]
                 }
               }
             } = json_response(conn, 200)

      assert {:ok, _} = Ecto.UUID.cast(order_id)
    end

    test "returns 400 with error reason products_already_purchased if the user already purchased the product",
         %{conn: conn} do
      user_id = "user_id"
      Repo.insert!(%User{user_id: user_id, data: %User.Data{product_ids: ["product"]}})

      conn =
        post(conn, "/api/orders", %{
          "order" => %{"user_id" => user_id, "items" => ["product"]}
        })

      assert %{"error" => "products_already_purchased"} = json_response(conn, 400)
    end

    test "returns 400 with error reason products_not_found if the items list is empty",
         %{conn: conn} do
      conn =
        post(conn, "/api/orders", %{
          "order" => %{"user_id" => "user_id", "items" => []}
        })

      assert %{"error" => "products_not_found"} = json_response(conn, 400)
    end

    test "returns 400 with error reason products_not_found if one of the given items does not exist",
         %{conn: conn} do
      conn =
        post(conn, "/api/orders", %{
          "order" => %{"user_id" => "user_id", "items" => ["inexistent_product"]}
        })

      assert %{"error" => "products_not_found"} = json_response(conn, 400)
    end

    test "returns 400 with error reason insufficient_balance if the user does not have enough balance to purchase the product",
         %{conn: conn} do
      user_id = "user_id"
      Repo.insert!(%User{user_id: user_id, data: %User.Data{balance: 1}})

      Repo.insert!(%Product{id: "product", name: "Product", price: 10})

      conn =
        post(conn, "/api/orders", %{
          "order" => %{"user_id" => user_id, "items" => ["product"]}
        })

      assert %{"error" => "insufficient_balance"} = json_response(conn, 400)
    end
  end
end
