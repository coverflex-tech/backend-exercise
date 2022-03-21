defmodule BackendWeb.UserControllerTest do
  use BackendWeb.ConnCase
  use Builders

  describe "get user" do
    test "should create a user givin a new valid id", %{conn: conn} do
      conn = get(conn, Routes.user_path(conn, :show, "frodo"))
      assert %{"user_id" => "frodo"} = json_response(conn, 200)["user"]
    end
  end
end
