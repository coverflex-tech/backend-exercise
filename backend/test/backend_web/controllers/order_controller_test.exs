defmodule BackendWeb.OrderControllerTest do
  use BackendWeb.ConnCase

  import Backend.BenefitsFixtures

  @create_attrs %{items: ["netflix"], user_id: "foo"}
  @invalid_attrs %{items: [], user_id: "bar"}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "create order" do
    test "renders order when data is valid", %{conn: conn} do
      product_fixture(%{string_id: "netflix", name: "Netflix", price: 7542})
      conn = post(conn, Routes.order_path(conn, :create), order: @create_attrs)
      assert %{"data" => %{"items" => [], "total" => 7542}} = json_response(conn, 201)["order"]
    end

    test "renders error when user already bought product", %{conn: conn} do
      product_fixture(%{string_id: "netflix", name: "Netflix", price: 7542})
      post(conn, Routes.order_path(conn, :create), order: @create_attrs)

      conn = post(conn, Routes.order_path(conn, :create), order: @create_attrs)
      assert %{"error" => "products_already_purchased"} = json_response(conn, 400)
    end

    test "renders error when user balance isn't enough", %{conn: conn} do
      product_fixture(%{string_id: "netflix", name: "Netflix", price: 2_147_483_647})
      conn = post(conn, Routes.order_path(conn, :create), order: @create_attrs)

      assert %{"error" => "insufficient_balance"} = json_response(conn, 400)
    end

    test "renders error when product is not found", %{conn: conn} do
      conn = post(conn, Routes.order_path(conn, :create), order: @create_attrs)
      assert %{"error" => "products_not_found"} = json_response(conn, 400)
    end

    test "renders changeset errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.order_path(conn, :create), order: @invalid_attrs)

      assert %{"products" => ["should have at least 1 item(s)"]} ==
               json_response(conn, 422)["errors"]
    end
  end
end
