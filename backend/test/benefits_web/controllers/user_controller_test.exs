defmodule BenefitsWeb.UserControllerTest do
  use BenefitsWeb.ConnCase

  alias Benefits.Accounts

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "show user" do
    test "404 error when user_id doesn't exist", %{conn: conn} do
      conn = get(conn, Routes.user_path(conn, :show, "inexistent_user_id"))
      assert json_response(conn, 404)["errors"]["detail"] == "Not Found"
    end

    test "renders user info when user_id exists", %{conn: conn} do
      {:ok, user} = Accounts.create_user(%{balance: 120.5, user_id: "show_user_id"})
      conn = get(conn, Routes.user_path(conn, :show, user.user_id))

      assert %{
               "user_id" => user.user_id,
               "data" => %{
                 "balance" => 120.5,
                 "product_ids" => []
               }
             } == json_response(conn, 200)["user"]
    end
  end

  describe "create user" do
    test "renders user when data is valid", %{conn: conn} do
      user_id = "create_user_id"
      attrs = %{balance: 120.5, user_id: user_id}

      res_user = %{
        "user_id" => user_id,
        "data" => %{
          "balance" => 120.5,
          "product_ids" => []
        }
      }

      conn = post(conn, Routes.user_path(conn, :create), user: attrs)
      assert res_user == json_response(conn, 201)["user"]

      conn = get(conn, Routes.user_path(conn, :show, user_id))
      assert res_user == json_response(conn, 200)["user"]
    end

    test "422 error when user_id has already been taken", %{conn: conn} do
      user_id = "create_duplicated_user_id"
      attrs = %{balance: 120.5, user_id: user_id}

      conn = post(conn, Routes.user_path(conn, :create), user: attrs)

      assert %{
               "user_id" => user_id,
               "data" => %{
                 "balance" => 120.5,
                 "product_ids" => []
               }
             } == json_response(conn, 201)["user"]

      conn = post(conn, Routes.user_path(conn, :create), user: attrs)
      assert json_response(conn, 422)["errors"]["user_id"] == ["has already been taken"]
    end

    test "422 error when balance is not positive", %{conn: conn} do
      user_id = "create_negative_balance_user_id"
      attrs = %{balance: -120.5, user_id: user_id}

      conn = post(conn, Routes.user_path(conn, :create), user: attrs)
      assert json_response(conn, 422)["errors"]["balance"] == ["Balance must be non-negative"]
    end
  end
end
