defmodule BenefitsWeb.ProductControllerTest do
  use BenefitsWeb.ConnCase

  import Benefits.ProductsFixtures

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all products", %{conn: conn} do
      p1 = product_fixture(%{name: "Netflix", price: Decimal.new("100.00")})
      p2 = product_fixture(%{name: "Amazon", price: Decimal.new("50.00")})
      p3 = product_fixture(%{name: "Hulu", price: Decimal.new("74.99")})
      p4 = product_fixture(%{name: "Disney+", price: Decimal.new("18.23")})

      conn = get(conn, Routes.product_path(conn, :index))

      assert json_response(conn, 200) == %{
               "products" => [
                 %{"id" => p1.id, "name" => "Netflix", "price" => 100.0},
                 %{"id" => p2.id, "name" => "Amazon", "price" => 50.0},
                 %{"id" => p3.id, "name" => "Hulu", "price" => 74.99},
                 %{"id" => p4.id, "name" => "Disney+", "price" => 18.23}
               ]
             }
    end
  end
end
