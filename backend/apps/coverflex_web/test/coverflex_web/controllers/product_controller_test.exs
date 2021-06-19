defmodule CoverflexWeb.ProductControllerTest do
  use CoverflexWeb.ConnCase
  alias TestHelper.CoverflexWeb.Fixtures

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all products", %{conn: conn} do
      product1 = Fixtures.product_fixture()
      product2 = Fixtures.product_fixture()

      expected_products = [
        %{"id" => product1.id, "name" => product1.name, "price" => product1.price},
        %{"id" => product2.id, "name" => product2.name, "price" => product2.price}
      ]

      conn = get(conn, Routes.product_path(conn, :index))

      assert %{
               "products" => ^expected_products
             } = json_response(conn, 200)
    end
  end
end
