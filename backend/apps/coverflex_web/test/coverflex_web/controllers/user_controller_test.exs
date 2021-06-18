defmodule CoverflexWeb.UserControllerTest do
  use CoverflexWeb.ConnCase

  alias TestHelper.Fixtures

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "get user" do
    setup [:create_user]

    test "already created user", %{conn: conn, user: %{user_id: user_id, id: id}} do
      conn = get(conn, Routes.user_path(conn, :show, user_id))

      assert %{
               "user" => %{
                 "id" => ^id,
                 "user_id" => ^user_id
               }
             } = json_response(conn, 200)
    end

    test "creates a new user when do not exist", %{conn: conn} do
      conn = get(conn, Routes.user_path(conn, :show, "adalovelace"))

      assert %{
               "user" => %{
                 "id" => _some_id,
                 "user_id" => "adalovelace"
               }
             } = json_response(conn, 201)
    end
  end

  defp create_user(_) do
    user = Fixtures.user_fixture()
    %{user: user}
  end
end
