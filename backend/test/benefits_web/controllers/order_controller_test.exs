defmodule BenefitsWeb.OrderControllerTest do
  use BenefitsWeb.ConnCase

  import Benefits.{OrdersFixtures, UsersFixtures, ProductsFixtures}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "create order" do
    test "renders order when data is valid", %{conn: conn} do
      user = user_fixture(%{user_id: "rafa"})
      product1 = product_fixture(%{name: "Hulu", price: Decimal.new("74.99")})
      product2 = product_fixture(%{name: "Disney+", price: Decimal.new("18.23")})

      create_attrs = %{
        "order" => %{
          "items" => [product1.id, product2.id],
          "user_id" => user.user_id
        }
      }

      conn = post(conn, Routes.order_path(conn, :create), create_attrs)

      items = [product1.id, product2.id]

      assert %{
               "order_id" => _,
               "data" => %{"items" => ^items, "total" => 93.22}
             } = json_response(conn, 201)["order"]
    end


  end

  describe "business validations" do
    test "it doesn't allow order creation when user ballance is insufficient", %{conn: conn} do
      user = user_fixture(%{user_id: "rafa", balance: Decimal.new("90")})

      product1 = product_fixture(%{name: "Hulu", price: Decimal.new("74.99")})
      product2 = product_fixture(%{name: "Disney+", price: Decimal.new("18.23")})

      create_attrs = %{
        "order" => %{
          "items" => [product1.id, product2.id],
          "user_id" => user.user_id
        }
      }

      conn = post(conn, Routes.order_path(conn, :create), create_attrs)

      assert json_response(conn, 400) == %{"error" => "insufficient_balance"}
    end

    test "it doesn't allow order creation for unknown products", %{conn: conn} do
      user = user_fixture(%{user_id: "rafa", balance: Decimal.new("90")})

      create_attrs = %{
        "order" => %{
          "items" => [54],
          "user_id" => user.user_id
        }
      }

      conn = post(conn, Routes.order_path(conn, :create), create_attrs)

      assert json_response(conn, 400) == %{"error" => "products_not_found"}
    end

    test "it doesn't allow order creation for already purchased products", %{conn: conn} do
      user = user_fixture(%{user_id: "rafa", balance: Decimal.new("500")})

      product1 = product_fixture(%{name: "Hulu", price: Decimal.new("74.99")})
      product2 = product_fixture(%{name: "Disney+", price: Decimal.new("18.23")})

      order_fixture(%{user_id: user.user_id, items: [product1.id]})

      create_attrs = %{
        "order" => %{
          "items" => [product1.id, product2.id],
          "user_id" => user.user_id
        }
      }

      conn = post(conn, Routes.order_path(conn, :create), create_attrs)

      assert json_response(conn, 400) == %{"error" => "products_already_purchased"}
    end
  end
end
