defmodule BenefitsWeb.ProductControllerTest do
  use BenefitsWeb.ConnCase, async: true
  import Benefits.Factory

  describe "index" do
    test "without any products", %{conn: conn} do
      conn = get(conn, Routes.product_path(conn, :index))

      assert json_response(conn, 200) === %{"products" => []}
    end

    test "with 1 product", %{conn: conn} do
      product = insert(:product)
      conn = get(conn, Routes.product_path(conn, :index))

      assert json_response(conn, 200) === %{
               "products" => [
                 %{"id" => product.identifier, "name" => product.name, "price" => product.price}
               ]
             }
    end

    test "with multiple product", %{conn: conn} do
      insert_list(10, :product)
      conn = get(conn, Routes.product_path(conn, :index))

      assert %{"products" => products_list} = json_response(conn, 200)
      assert length(products_list) === 10
    end
  end
end
