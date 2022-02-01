defmodule BenefitsWeb.ProductControllerTest do
  use BenefitsWeb.ConnCase

  alias Benefits.Perks

  def fixture(:product) do
    attrs = %{identifier: "product1", name: "Product1", price: 50.6}
    {:ok, product} = Perks.create_product(attrs)
    product
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all products", %{conn: conn} do
      conn = get(conn, Routes.product_path(conn, :index))
      assert json_response(conn, 200)["products"] == []

      product = fixture(:product)

      assert [
               %{
                 "id" => product.identifier,
                 "name" => product.name,
                 "price" => product.price
               }
             ] == json_response(get(conn, Routes.product_path(conn, :index)), 200)["products"]
    end
  end
end
