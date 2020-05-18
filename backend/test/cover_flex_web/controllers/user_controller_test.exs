defmodule CoverFlex.UserControllerTest do
  use CoverFlexWeb.ConnCase
  alias CoverFlexWeb.Router.Helpers, as: Routes

  describe "show" do
    test "shows user when given ID", %{conn: conn} do
      conn = get(conn, Routes.user_path(conn, :show, "alice"))
      expected_user = %{
        "user_id" => "alice",
        "data" => %{
          "balance" => 500,
          "product_ids" => []
        }
      }
      assert json_response(conn, 200)["user"] == expected_user
    end
  end
end
