defmodule CompanyBenefitsWeb.UserControllerTest do
  use CompanyBenefitsWeb.ConnCase

  alias CompanyBenefits.Accounts
  alias CompanyBenefits.Accounts.User

  @username "some username"

  def fixture(:user) do
    {:ok, user} = Accounts.login(@username)
    user
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "login" do
    test "should create user", %{conn: conn} do
      assert Accounts.UserContext.list_users() |> length() === 0
      conn = get(conn, user_path(conn, :login, @username))
      assert Accounts.UserContext.list_users() |> length() === 1
    end

    test "should return an existing user", %{conn: conn} do
      %User{username: username} = fixture(:user)
      assert Accounts.UserContext.list_users() |> length() === 1

      response =
        get(conn, user_path(conn, :login, username))
        |> json_response(200)

      assert response["user"]["user_id"] == username

      assert Accounts.UserContext.list_users() |> length() === 1
    end
  end
end
