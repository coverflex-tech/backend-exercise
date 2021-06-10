defmodule CoverflexWeb.UserControllerTest do
  use CoverflexWeb.ConnCase

  alias Coverflex.Accounts

  @create_attrs %{
    user_id: "some user_id"
  }

  def fixture(:user) do
    {:ok, user} = Accounts.create_user(@create_attrs)
    user
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "get user" do
    setup [:create_user]

    test "already created user", %{conn: conn, user: %{id: id}} do
      conn = get(conn, Routes.user_path(conn, :show, id))

      assert %{
               "id" => ^id,
               "user_id" => "some user_id"
             } = json_response(conn, 200)["data"]
    end
  end

  defp create_user(_) do
    user = fixture(:user)
    %{user: user}
  end
end