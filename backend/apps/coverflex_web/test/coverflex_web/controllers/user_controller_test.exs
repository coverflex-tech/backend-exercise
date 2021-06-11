defmodule CoverflexWeb.UserControllerTest do
  use CoverflexWeb.ConnCase

  alias Coverflex.Accounts

  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(%{user_id: "user#{System.unique_integer([:positive])}"})
      |> Accounts.create_user()

    user
  end

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
             } = json_response(conn, 200)["data"]
    end

    test "creates a new user when do not exist", %{conn: conn} do
      conn = get(conn, Routes.user_path(conn, :show, "adalovelace"))

      assert %{
               "user" => %{
                 "id" => _some_id,
                 "user_id" => "adalovelace"
               }
             } = json_response(conn, 201)["data"]
    end
  end

  defp create_user(_) do
    user = user_fixture()
    %{user: user}
  end
end
