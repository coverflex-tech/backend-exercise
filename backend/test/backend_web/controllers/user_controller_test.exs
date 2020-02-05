defmodule BackendWeb.UserControllerTest do
  use BackendWeb.ConnCase

  alias Backend.Accounts

  @create_attrs %{
    data: %{},
    user_id: "some user_id"
  }

  def fixture(:user) do
    {:ok, user} = Accounts.create_user(@create_attrs)
    user
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "show when user doesn't exists" do
    test "renders a user", %{conn: conn} do
      conn = get(conn, Routes.user_path(conn, :show, "some user_id"))

      assert json_response(conn, 200)["user"]["user_id"] == "some user_id"
    end
  end

  describe "show when user exists" do
    setup [:create_user]

    test "renders a user", %{conn: conn} do
      conn = get(conn, Routes.user_path(conn, :show, "some user_id"))
      assert json_response(conn, 200)["user"]["user_id"] == "some user_id"
    end
  end

  defp create_user(_) do
    user = fixture(:user)
    {:ok, user: user}
  end
end
