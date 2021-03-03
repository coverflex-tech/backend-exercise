defmodule BackendWeb.ProductsControllerTest do
  use BackendWeb.ConnCase, async: true
  alias Backend.{Repo, Products.Product}

  describe "get" do
    test "returns all products", %{conn: conn} do
      # Arrange
      Repo.insert(%Product{id: "id1", name: "name1", price: 1})
      Repo.insert(%Product{id: "id2", name: "name2", price: 2})
      Repo.insert(%Product{id: "id3", name: "name3", price: 3})

      expected = %{
        "products" => [
          %{
            "id" => "id1",
            "name" => "name1",
            "price" => 1
          },
          %{
            "id" => "id2",
            "name" => "name2",
            "price" => 2
          },
          %{
            "id" => "id3",
            "name" => "name3",
            "price" => 3
          }
        ]
      }

      # Act
      actual =
        conn
        |> get("/api/products")
        |> json_response(200)

      # Assert
      assert ^expected = actual
    end

    test "returns empty list if no products exist", %{conn: conn} do
      # Arrange
      expected = %{
        "products" => []
      }

      # Act
      actual =
        conn
        |> get("/api/products")
        |> json_response(200)

      # Assert
      assert ^expected = actual
    end
  end
end
