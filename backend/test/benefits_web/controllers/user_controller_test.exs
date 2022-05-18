defmodule BenefitsWeb.UserControllerTest do
  use BenefitsWeb.ConnCase

  import Benefits.UsersFixtures

  alias Benefits.Users.User

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "show" do
    test "get user", %{conn: conn} do
      user = user_fixture(%{username: "rafa"})

      conn = get(conn, Routes.user_path(conn, :show, user.username))

      assert json_response(conn, 200) == %{
               "user" => %{
                 "data" => %{"balance" => "500", "product_ids" => []},
                 "user_id" => "rafa"
               }
             }
    end

    test "create user if one doesn't exist for that username", %{conn: conn} do
      conn = get(conn, Routes.user_path(conn, :show, "rafael_test"))

      assert json_response(conn, 200) == %{
               "user" => %{
                 "data" => %{"balance" => "500", "product_ids" => []},
                 "user_id" => "rafael_test"
               }
             }
    end
  end
end
