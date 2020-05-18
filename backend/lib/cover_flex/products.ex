defmodule CoverFlex.Products do
  @moduledoc """
  Products is the context that deals with benefits and their ordering of.
  """
  alias CoverFlex.Repo
  alias CoverFlex.Products.Product

  def list_products(), do: Repo.all(Product)
end
