defmodule BenefitsWeb.ProductControllerTest do
  use BenefitsWeb.ConnCase

  alias Benefits.Products

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "create product" do
    test "creates a new product when data is valid", %{conn: conn} do
      input = %{name: "Product", price: Enum.random(1..100)}
      conn = post(conn, Routes.product_path(conn, :create, input))

      %{
        "name" => name,
        "price" => price
      } = json_response(conn, 201)["data"]

      assert input.name == name
      assert input.price == price
    end

    test "fails when params are invalid", %{conn: conn} do
      input = %{invalid: "params"}
      conn = post(conn, Routes.product_path(conn, :create, input))

      assert %{
        "name" => ["can't be blank"],
        "price" => ["can't be blank"]
      } = json_response(conn, 422)["errors"]
    end
  end

  describe "list products" do
    test "renders a list of products", %{conn: conn} do
      Enum.each(1..10, fn i -> 
        Products.create_product(%{name: "Product #{i}", price: Enum.random(1..100)})
      end)

      conn = get(conn, Routes.product_path(conn, :index))
      products = json_response(conn, 200)["data"]

      assert length(products) == 10
    end
  end
end
