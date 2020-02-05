defmodule BackendWeb.ProductControllerTest do
  use BackendWeb.ConnCase

  alias Backend.Benefits

  @create_attrs %{
    id: "netflix",
    name: "Netflix",
    price: 42
  }

  def fixture(:product) do
    {:ok, product} = Benefits.create_product(@create_attrs)
    product
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    setup [:create_product]

    test "lists all products", %{conn: conn} do
      conn = get(conn, Routes.product_path(conn, :index))
      product = %{"id" => "netflix", "name" => "Netflix", "price" => 42}

      assert json_response(conn, 200)["products"] == [product]
    end
  end

  defp create_product(_) do
    product = fixture(:product)
    {:ok, product: product}
  end
end
