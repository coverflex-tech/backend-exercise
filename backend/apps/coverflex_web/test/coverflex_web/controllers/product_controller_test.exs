defmodule CoverflexWeb.ProductControllerTest do
  use CoverflexWeb.ConnCase
  alias TestHelper.Fixtures

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
    product = Fixtures.product_fixture()
    %{product: product}
  end
end
