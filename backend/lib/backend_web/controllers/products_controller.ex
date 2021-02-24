defmodule BackendWeb.ProductsController do
  use BackendWeb, :controller

  def list(conn, _args) do
    json(conn, %{products: Backend.Product.list()})
  end
end
