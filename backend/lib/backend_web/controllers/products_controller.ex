defmodule BackendWeb.ProductsController do
  use BackendWeb, :controller
  alias Backend.Products.Product

  @manager_module Application.compile_env!(:backend, [:modules, :product_manager])

  def list(conn, _) do
    case @manager_module.get() do
      {:error, reason} -> send_resp(conn, inspect(reason), 500)
      list -> json(conn, %{products: list})
    end
  end

  defimpl Jason.Encoder, for: [Product] do
    def encode(%{id: id, name: name, price: price}, opts) do
      Jason.Encode.map(
        %{
          id: id,
          name: name,
          price: price
        },
        opts
      )
    end
  end
end
