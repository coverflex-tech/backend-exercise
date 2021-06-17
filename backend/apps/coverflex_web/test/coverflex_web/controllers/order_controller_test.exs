defmodule CoverflexWeb.OrderControllerTest do
  use CoverflexWeb.ConnCase

  alias Coverflex.Orders
  alias TestHelper.Fixtures

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "create order" do
    test "renders order when data is valid", %{conn: conn} do
      assert length(Orders.list_orders()) == 0
      product1 = Fixtures.product_fixture()
      product2 = Fixtures.product_fixture()
      balance = product1.price + product2.price

      user = Fixtures.user_fixture(%{balance: balance}, with_account: true)

      payload = %{"user_id" => user.user_id, "items" => [product1.id, product2.id]}
      conn = post(conn, Routes.order_path(conn, :create), order: payload)

      total_expected = product1.price + product2.price

      assert %{"order" => %{"total" => ^total_expected}} = json_response(conn, 201)["data"]
      assert length(Orders.list_orders()) == 1
    end

    #    test "renders errors when data is invalid", %{conn: conn, user: user} do
    #      conn = post(conn, Routes.order_path(conn, :create), order: %{"user_id" => user.id})
    #
    #      assert json_response(conn, 422)["errors"] != %{}
    #    end
  end
end
