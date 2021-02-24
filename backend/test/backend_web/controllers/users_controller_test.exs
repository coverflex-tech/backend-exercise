defmodule BackendWeb.UsersControllerTest do
  use BackendWeb.ConnCase, async: true
  alias Backend.{Repo, User}

  describe "get or create user" do
    test "returns an existing user in the database with the given user_id", %{conn: conn} do
      user_id = "user_id"

      Repo.insert!(%User{user_id: user_id, data: %User.Data{}})

      expected_response = %{
        "user" => %{"user_id" => user_id, "data" => %{"balance" => 1000, "product_ids" => []}}
      }

      conn = get(conn, "/api/users/#{user_id}")

      assert expected_response == json_response(conn, 200)
    end

    test "returns a new user with the given user_id if it does not exist in the database", %{conn: conn} do
      user_id = "user_id"

      expected_response = %{
        "user" => %{"user_id" => user_id, "data" => %{"balance" => 1000, "product_ids" => []}}
      }

      conn = get(conn, "/api/users/#{user_id}")

      assert expected_response == json_response(conn, 200)
    end
  end
end
