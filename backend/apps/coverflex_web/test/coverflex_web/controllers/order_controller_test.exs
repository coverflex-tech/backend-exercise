defmodule CoverflexWeb.OrderControllerTest do
  use CoverflexWeb.ConnCase

  alias Coverflex.Orders
  alias TestHelper.Fixtures

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "create order" do
    setup [:create_user]

    test "renders order when data is valid", %{conn: conn, user: user} do
      conn = post(conn, Routes.order_path(conn, :create), order: %{"user_id" => user.id})

      assert %{"order" => %{"id" => id, "total" => 0}} = json_response(conn, 201)["data"]

      assert Orders.get_order!(id)
    end

    #    test "renders errors when data is invalid", %{conn: conn, user: user} do
    #      conn = post(conn, Routes.order_path(conn, :create), order: %{"user_id" => user.id})
    #
    #      assert json_response(conn, 422)["errors"] != %{}
    #    end
  end

  defp create_user(_) do
    user = Fixtures.user_fixture()
    %{user: user}
  end
end
