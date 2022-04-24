defmodule BackendWeb.UserControllerTest do
  use BackendWeb.ConnCase

  import Backend.BenefitsFixtures
  alias BackendWeb.AmountHelpers

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "show a user" do
    setup [:create_user]

    test "fetches a user", %{conn: conn, user: user} do
      conn = get(conn, Routes.user_path(conn, :show, user.user_id))

      expected = %{
        "user" => %{
          "user_id" => user.user_id,
          "data" => %{"balance" => AmountHelpers.centify(user.balance), "product_ids" => []}
        }
      }

      assert ^expected = json_response(conn, 200)
    end
  end

  defp create_user(_) do
    user = user_fixture()
    %{user: user}
  end
end
