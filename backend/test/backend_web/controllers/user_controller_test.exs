defmodule BackendWeb.UserControllerTest do
  use BackendWeb.ConnCase

  import Backend.BenefitsFixtures

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "get_or_create_user/2" do
    setup [:create_user]

    test "should get an existing user", %{conn: conn, user: user} do
      conn = get(conn, Routes.user_path(conn, :get_or_create_user, user.username))

      assert %{
               "user" => %{
                 "data" => %{"balance" => 50_000, "product_ids" => []},
                 "user_id" => "some username"
               }
             } == json_response(conn, 200)
    end

    test "should create an user when username doesn't exist", %{conn: conn} do
      conn = get(conn, Routes.user_path(conn, :get_or_create_user, "foo"))

      assert %{
               "user" => %{
                 "data" => %{"balance" => 50_000, "product_ids" => []},
                 "user_id" => "foo"
               }
             } = json_response(conn, 200)
    end
  end

  defp create_user(_) do
    user = user_fixture()
    %{user: user}
  end
end
