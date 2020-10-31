defmodule CompanyBenefits.Products do
  @moduledoc """
  The Products API.
  """
  alias CompanyBenefits.Products.Product

  @doc """
  Sums product prices.
  """
  def sum_prices(products) when is_list(products) do
    products
    |> Enum.map(fn %Product{} = product -> product.price end)
    |> Enum.sum()
  end
end
