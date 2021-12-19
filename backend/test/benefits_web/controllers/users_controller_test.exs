defmodule BenefitsWeb.UserControllerTest do
  use BenefitsWeb.ConnCase

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "show or create user" do
    test "creates a bew user when data is valid", %{conn: conn} do
      username = "User name"

      conn = get(conn, Routes.user_path(conn, :show_or_create, username))
      
      assert %{
               "balance" => 500.0,
               "username" => ^username
             } = json_response(conn, 201)["data"]
    end

    test "renders user when data is valid", %{conn: conn} do
      username = "User name"

      # Creating the user
      conn = get(conn, Routes.user_path(conn, :show_or_create, username))

      # Returning the existing user
      conn = get(conn, Routes.user_path(conn, :show_or_create, username))

      assert %{
               "balance" => 500.0,
               "username" => ^username
             } = json_response(conn, 200)["data"]
    end
  end
end
