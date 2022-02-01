defmodule BenefitsWeb.OrderControllerTest do
  use BenefitsWeb.ConnCase

  alias Benefits.Accounts
  alias Benefits.Perks

  setup %{conn: conn} do
    # create 3 products
    Perks.create_product(%{identifier: "product1", name: "Product1", price: 120.5})
    Perks.create_product(%{identifier: "product2", name: "Product2", price: 12.5})
    Perks.create_product(%{identifier: "product3", name: "Product3", price: 1.5})

    # create two user
    Accounts.create_user(%{balance: 130.0, user_id: "user1"})
    Accounts.create_user(%{balance: 150.0, user_id: "user2"})

    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "create order" do
    test "400 error when invalid input for items", %{conn: conn} do
      conn =
        post(conn, Routes.order_path(conn, :create),
          order: %{user_id: "user1", items: "inexistent1"}
        )

      assert json_response(conn, 400)["error"] == "products_not_found"

      conn = post(conn, Routes.order_path(conn, :create), order: %{user_id: "user1", items: []})
      assert json_response(conn, 400)["error"] == "products_not_found"

      conn =
        post(conn, Routes.order_path(conn, :create),
          order: %{user_id: "user1", items: ["inexistent1"]}
        )

      assert json_response(conn, 400)["error"] == "products_not_found"

      conn =
        post(conn, Routes.order_path(conn, :create),
          order: %{user_id: "user1", items: ["inexistent1", "inexistent2"]}
        )

      assert json_response(conn, 400)["error"] == "products_not_found"

      conn =
        post(conn, Routes.order_path(conn, :create),
          order: %{user_id: "user1", items: ["product1", "inexistent1"]}
        )

      assert json_response(conn, 400)["error"] == "products_not_found"
    end

    test "400 error when invalid user_id", %{conn: conn} do
      conn =
        post(conn, Routes.order_path(conn, :create),
          order: %{user_id: "inexistent", items: ["product1"]}
        )

      assert json_response(conn, 400)["error"] == "Inexistent User"

      conn =
        post(conn, Routes.order_path(conn, :create),
          order: %{user_id: "user3", items: ["product1"]}
        )

      assert json_response(conn, 400)["error"] == "Inexistent User"
    end

    test "400 error when total price higher than user's balance", %{conn: conn} do
      conn =
        post(conn, Routes.order_path(conn, :create),
          order: %{user_id: "user1", items: ["product1", "product2"]}
        )

      assert json_response(conn, 400)["error"] == "insufficient_balance"
    end

    test "400 error when user tries to purchase an item that already have", %{conn: conn} do
      conn =
        post(conn, Routes.order_path(conn, :create),
          order: %{user_id: "user1", items: ["product2"]}
        )

      conn =
        post(conn, Routes.order_path(conn, :create),
          order: %{user_id: "user1", items: ["product2"]}
        )

      assert json_response(conn, 400)["error"] == "products_already_purchased"
    end

    test "renders order when data is valid", %{conn: conn} do
      identifiers = ["product2", "product3"]
      user_id = "user2"

      conn =
        post(conn, Routes.order_path(conn, :create),
          order: %{user_id: user_id, items: identifiers}
        )

      order = json_response(conn, 201)["order"]

      assert order["total"] == 12.5 + 1.5
      assert order["items"] == identifiers

      conn = get(conn, Routes.user_path(conn, :show, user_id))
      user = json_response(conn, 200)["user"]

      assert user["data"]["balance"] == 150.0 - order["total"]
      assert user["data"]["product_ids"] == order["items"]
    end
  end
end
