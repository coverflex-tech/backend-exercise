defmodule BackendWeb.UserControllerTest do
  use BackendWeb.ConnCase

  import Backend.UsersFixtures

  alias Backend.Users.User

  @create_attrs %{
    balance: 4200,
    user_id: "test-user-id"
  }
  @update_attrs %{
    balance: 4300
  }
  @invalid_attrs %{balance: nil, user_id: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all users", %{conn: conn} do
      conn = get(conn, Routes.user_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "show" do
    test "should create user if supplied user_id doesn't exist", %{conn: conn} do
      user_id = "inexistent-user-id"
      conn = get(conn, Routes.user_path(conn, :show, user_id))

      assert %{
               "user_id" => _user_id,
               "data" => %{"balance" => 0.0, "products_ids" => []}
             } = json_response(conn, 200)["user"]
    end
  end

  describe "create user" do
    test "renders user when data is valid", %{conn: conn} do
      conn = post(conn, Routes.user_path(conn, :create), user: @create_attrs)
      assert %{"user_id" => id} = json_response(conn, 201)["user"]

      conn = get(conn, Routes.user_path(conn, :show, id))

      assert %{
               "user_id" => "test-user-id",
               "data" => %{"balance" => 42.0, "products_ids" => []}
             } = json_response(conn, 200)["user"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.user_path(conn, :create), user: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update user" do
    setup [:create_user]

    test "renders user when data is valid", %{conn: conn, user: %User{user_id: user_id} = user} do
      conn = put(conn, Routes.user_path(conn, :update, user), user: @update_attrs)
      assert %{"user_id" => ^user_id} = json_response(conn, 200)["user"]

      conn = get(conn, Routes.user_path(conn, :show, user_id))

      assert %{
               "user_id" => "test-user-id",
               "data" => %{"balance" => 43.0, "products_ids" => []}
             } = json_response(conn, 200)["user"]
    end

    test "renders errors when data is invalid", %{conn: conn, user: user} do
      conn = put(conn, Routes.user_path(conn, :update, user), user: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete user" do
    setup [:create_user]

    test "deletes chosen user", %{conn: conn, user: user} do
      conn = delete(conn, Routes.user_path(conn, :delete, user))
      assert response(conn, 204)
    end
  end

  defp create_user(_) do
    user = user_fixture()
    %{user: user}
  end
end
