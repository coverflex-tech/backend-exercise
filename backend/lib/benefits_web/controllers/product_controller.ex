defmodule BenefitsWeb.ProductController do
  @moduledoc """
  Contains the controller functions that respond to specific endpoints related to product resources.
  """

  use BenefitsWeb, :controller

  alias Benefits.Perks

  @spec index(Plug.Conn.t(), any) :: Plug.Conn.t()
  def index(conn, _params) do
    products = Perks.list_products()
    render(conn, "index.json", products: products)
  end
end
