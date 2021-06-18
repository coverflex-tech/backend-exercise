defmodule CoverflexWeb.PageControllerTest do
  use CoverflexWeb.ConnCase

  test "access index redirect to api", %{conn: conn} do
    conn = get(conn, Routes.page_path(conn, :index))

    assert redirected_to(conn) =~ Routes.product_path(conn, :index)
  end
end
