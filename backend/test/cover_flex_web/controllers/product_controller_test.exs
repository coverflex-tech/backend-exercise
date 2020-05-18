defmodule CoverFlex.ProductControllerTest do
  use CoverFlexWeb.ConnCase
  alias CoverFlexWeb.Router.Helpers, as: Routes

  describe "index" do
    test "shows list of products", %{conn: conn} do
      conn = get(conn, Routes.product_path(conn, :index))
      assert json_response(conn, 200)["products"] == []
    end
  end
end
