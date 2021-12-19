defmodule BenefitsWeb.OrderControllerTest do
  use BenefitsWeb.ConnCase
  import Benefits.UsersFixtures
  import Benefits.ProductsFixtures

  setup %{conn: conn} do
    user = user_fixture(balance: 100)

    items =
      Enum.map(1..10, fn _ ->
        product = product_fixture()

        product.id
      end)

    {:ok, conn: put_req_header(conn, "accept", "application/json"), user: user, items: items}
  end

  describe "create order" do
    test "creates a new order when data is valid", %{conn: conn, user: user, items: items} do
      input = %{username: user.username, items: items}
      conn = post(conn, Routes.order_path(conn, :create, input))

      body = json_response(conn, 201)["order"]

      assert length(body["items"]) == 10
      assert List.first(body["items"])["id"] == List.first(items)
    end

    test "fails when params are invalid", %{conn: conn} do
      input = %{invalid: "params"}
      conn = post(conn, Routes.order_path(conn, :create, input))

      assert %{
               "username" => ["can't be blank"],
               "items" => ["can't be blank"]
             } = json_response(conn, 422)["errors"]
    end

    test "fails when products don't exist", %{conn: conn, user: user} do
      input = %{username: user.username, items: [1000, 2000]}
      conn = post(conn, Routes.order_path(conn, :create, input))

      assert %{"error" => "products_not_found"} = json_response(conn, 422)
    end

    test "fails when products aren't available", %{conn: conn, user: user, items: items} do
      input = %{username: user.username, items: items}

      # Placing the first valid order
      conn = post(conn, Routes.order_path(conn, :create, input))

      # Trying to order unavailable products
      conn = post(conn, Routes.order_path(conn, :create, input))

      assert %{"error" => "products_already_purchased"} = json_response(conn, 422)
    end

    test "fails when user has no balance", %{conn: conn, items: items} do
      user = user_fixture(balance: 1)
      input = %{username: user.username, items: items}

      conn = post(conn, Routes.order_path(conn, :create, input))

      assert %{"error" => "insufficient_balance"} = json_response(conn, 422)
    end
  end
end
