defmodule BenefitsWeb.OrderControllerTest do
  use BenefitsWeb.ConnCase
  import Benefits.UsersFixtures
  import Benefits.ProductsFixtures

  alias Benefits.Orders

  setup %{conn: conn} do
    user = user_fixture(balance: 100)

    items =
      Enum.map(1..10, fn i ->
        product = product_fixture(name: "Product #{i}", price: 5)

        product.name
      end)

    {:ok, conn: put_req_header(conn, "accept", "application/json"), user: user, items: items}
  end

  describe "create order" do
    test "creates a new order when data is valid", %{conn: conn, user: user, items: items} do
      input = %{username: user.username, items: items}
      conn = post(conn, Routes.order_path(conn, :create, input))

      body = json_response(conn, 201)["order"]

      assert length(body["items"]) == 10
      assert List.first(body["items"])["name"] == List.first(items)
      assert body["user"]["username"] == user.username
      assert body["user"]["balance"] == 50
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
      input = %{username: user.username, items: ["Invalid", "Products"]}
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

  describe "list orders" do
    test "renders a list of orders", %{conn: conn, user: user, items: items} do
      Orders.create_order(user.username, items)

      conn = get(conn, Routes.order_path(conn, :index))
      body = json_response(conn, 200)["orders"]

      assert length(body) == 1

      first_order = List.first(body)

      assert List.first(first_order["items"])["name"] == List.first(items)
      assert first_order["user"]["username"] == user.username
      assert first_order["user"]["balance"] == 50
    end
  end
end
