defmodule CoverflexWeb.PageController do
  use CoverflexWeb, :controller

  action_fallback(CoverflexWeb.FallbackController)

  def index(conn, _params) do
    redirect(conn, to: Routes.product_path(conn, :index))
  end
end
