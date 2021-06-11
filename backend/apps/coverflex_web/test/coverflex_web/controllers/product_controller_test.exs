defmodule CoverflexWeb.ProductControllerTest do
  use CoverflexWeb.ConnCase

  alias Coverflex.Products

  @create_attrs %{
    name: "some name",
    price: 42
  }

  def fixture(:product) do
    {:ok, product} = Products.create_product(@create_attrs)
    product
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    setup [:create_product]

    test "lists all products", %{conn: conn, product: %{id: id, name: name, price: price}} do
      conn = get(conn, Routes.product_path(conn, :index))

      assert %{
               "products" => [
                 %{"id" => ^id, "name" => ^name, "price" => ^price}
               ]
             } = json_response(conn, 200)
    end
  end

  defp create_product(_) do
    product = fixture(:product)
    %{product: product}
  end
end
