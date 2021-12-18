defmodule BenefitsWeb.PageController do
  use BenefitsWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
