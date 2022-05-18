defmodule BenefitsWeb.OrderControllerTest do
  use BenefitsWeb.ConnCase

  import Benefits.{OrdersFixtures, UsersFixtures, ProductsFixtures}

  alias Benefits.Orders.Order

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "create order" do
    test "renders order when data is valid", %{conn: conn} do
      # create user
      user = user_fixture(%{username: "rafa"})
      # create items
      product1 = product_fixture(%{name: "Hulu", price: Decimal.new("74.99")})
      product2 = product_fixture(%{name: "Disney+", price: Decimal.new("18.23")})

      create_attrs = %{
        "order" => %{
          "items" => [product1.id, product2.id],
          "user_id" => user.username
        }
      }

      # input {"order": {"items": ["product-1", "product-2"], "user_id": "johndoe"}}
      # output 200 {"order": {"order_id": "123", "data": {"items": [...], "total": 500}}}

      conn = post(conn, Routes.order_path(conn, :create), create_attrs)

      items = [product1.id, product2.id]

      assert %{
               "order_id" => _,
               "data" => %{"items" => ^items, "total" => 93.22}
             } = json_response(conn, 201)["order"]
    end

    # test "renders errors when data is invalid", %{conn: conn} do
    #   conn = post(conn, Routes.order_path(conn, :create), order: @invalid_attrs)
    #   assert json_response(conn, 422)["errors"] != %{}
    # end
  end
end
