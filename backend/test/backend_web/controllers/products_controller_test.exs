defmodule BackendWeb.ProductsControllerTest do
  use BackendWeb.ConnCase, async: true

  alias Backend.Repo
  alias Backend.Products.Product

  describe "list/2" do
    setup do
      product = %Product{
        id: "iphone",
        name: "Iphone 3",
        price: 200.37
      }

      product2 = %Product{
        id: "dog",
        name: "Beethoven",
        price: 163.99
      }

      product3 = %Product{
        id: "youtube",
        name: "Youtube Premium",
        price: 20.99
      }

      Repo.insert!(product)
      Repo.insert!(product2)
      Repo.insert!(product3)

      {:ok, %{}}
    end

    test "should return all products", %{conn: conn} do
      response =
        conn
        |> get(Routes.products_path(conn, :list))
        |> json_response(200)

      assert %{
               "products" => [
                 %{"id" => "iphone", "name" => "Iphone 3", "price" => "200.37"},
                 %{"id" => "dog", "name" => "Beethoven", "price" => "163.99"},
                 %{"id" => "youtube", "name" => "Youtube Premium", "price" => "20.99"}
               ]
             } == response
    end
  end
end
