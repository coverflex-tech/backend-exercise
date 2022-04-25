defmodule BackendWeb.OrderControllerTest do
  use BackendWeb.ConnCase

  import Backend.BenefitsFixtures

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "create order" do
    test "renders order when data is valid", %{conn: conn} do
      conn = post(conn, Routes.order_path(conn, :create), order: order_params([]))
      assert %{"data" => %{"items" => [], "total" => 0.0}} = json_response(conn, 201)["order"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.order_path(conn, :create), order: order_params(["a banana peel"]))
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  defp order_params(items) do
    user = user_fixture()
    %{"items" => items, "user_id" => user.user_id}
  end
end
