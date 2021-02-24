defmodule BackendWeb.ProductsControllerTest do
  use BackendWeb.ConnCase, async: true
  alias Backend.{Repo, Product}

  describe "list existing products" do
    test "returns all existing products in the database", %{conn: conn} do
      Repo.insert!(%Product{id: "product_a", name: "Product A", price: 10})
      Repo.insert!(%Product{id: "product_b", name: "Product B", price: 20})

      expected_response = %{
        "products" => [
          %{"id" => "product_a", "name" => "Product A", "price" => 10},
          %{"id" => "product_b", "name" => "Product B", "price" => 20}
        ]
      }

      conn = get(conn, "/api/products")

      assert expected_response == json_response(conn, 200)
    end

    test "returns an empty list if there are no products in the database", %{conn: conn} do
      expected_response = %{"products" => []}

      conn = get(conn, "/api/products")

      assert expected_response == json_response(conn, 200)
    end
  end
end
