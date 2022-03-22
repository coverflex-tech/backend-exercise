defmodule Backend.Products do
  @moduledoc """
  Products Contexts used to expose Products API and common functions of Products
  """
  alias Backend.Products.List

  defdelegate list_products, to: List, as: :call
end
