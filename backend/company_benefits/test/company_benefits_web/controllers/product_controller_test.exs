defmodule CompanyBenefitsWeb.ProductControllerTest do
  use CompanyBenefitsWeb.ConnCase

  alias CompanyBenefits.Products.ProductContext
  alias CompanyBenefits.Products.Product

  @create_attrs %{identifier: "some identifier", name: "some name", price: 120.5}

  def fixture(:product) do
    {:ok, product} = ProductContext.create_product(@create_attrs)
    product
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists 0 products", %{conn: conn} do
      conn = get(conn, product_path(conn, :index))
      assert json_response(conn, 200)["products"] == []
    end

    test "lists all products", %{conn: conn} do
      %Product{identifier: identifier} = fixture(:product)
      conn = get(conn, product_path(conn, :index))
      [result] = json_response(conn, 200)["products"]
      assert result["id"] == identifier
    end
  end
end
