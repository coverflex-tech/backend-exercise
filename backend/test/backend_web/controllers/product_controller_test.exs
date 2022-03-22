defmodule BackendWeb.ProductControllerTest do
  use BackendWeb.ConnCase

  import Backend.BenefitsFixtures

  @create_attrs %{
    name: "some name",
    price: 42,
    string_id: "some string_id"
  }
  @invalid_attrs %{name: nil, price: nil, string_id: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    setup [:create_product]

    test "lists all products", %{conn: conn} do
      conn = get(conn, Routes.product_path(conn, :index))

      assert [%{"id" => "some string_id", "name" => "some name", "price" => 42}] =
               json_response(conn, 200)["products"]
    end
  end

  describe "create product" do
    test "renders product when data is valid", %{conn: conn} do
      conn = post(conn, Routes.product_path(conn, :create), product: @create_attrs)

      assert %{
               "id" => "some string_id",
               "name" => "some name",
               "price" => 42
             } = json_response(conn, 201)["product"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.product_path(conn, :create), product: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  defp create_product(_) do
    product = product_fixture()
    %{product: product}
  end
end
