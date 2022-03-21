defmodule BackendWeb.ProductControllerTest do
  use BackendWeb.ConnCase
  use Builders

  describe "get products" do
    test "should return a list of products", %{conn: conn} do
      create_product(id: "p1", name: "P1", price: Decimal.new("10.00"))
      conn = get(conn, Routes.product_path(conn, :get))

      assert [%{"id" => "p1", "name" => "P1", "price" => "10.00"}] =
               json_response(conn, 200)["products"]
    end
  end
end
