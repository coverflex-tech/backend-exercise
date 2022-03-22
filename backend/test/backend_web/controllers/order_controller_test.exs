defmodule BackendWeb.OrderControllerTest do
  use BackendWeb.ConnCase

  @create_attrs %{
    total_value: 42
  }
  @invalid_attrs %{total_value: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "create order" do
    test "renders order when data is valid", %{conn: conn} do
      conn = post(conn, Routes.order_path(conn, :create), order: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["order"]

      assert %{"id" => ^id, "data" => %{"items" => [], "total" => 42}} =
               json_response(conn, 201)["order"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.order_path(conn, :create), order: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end
end
