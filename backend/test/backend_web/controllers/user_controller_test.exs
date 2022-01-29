defmodule BenefitsWeb.UserControllerTest do
  use BenefitsWeb.ConnCase, async: true
  import Benefits.Factory

  describe "show" do
    test "show info from non existing user", %{conn: conn} do
      conn = get(conn, Routes.user_path(conn, :show, "test"))

      assert json_response(conn, 200) === %{
               "user" => %{
                 "data" => %{"balance" => 0.0, "product_ids" => []},
                 "user_id" => "test"
               }
             }
    end

    test "show info from existing user", %{conn: conn} do
      user = insert(:user)

      conn = get(conn, Routes.user_path(conn, :show, user.username))

      assert json_response(conn, 200) === %{
               "user" => %{
                 "data" => %{"balance" => user.balance, "product_ids" => []},
                 "user_id" => user.username
               }
             }
    end
  end
end
