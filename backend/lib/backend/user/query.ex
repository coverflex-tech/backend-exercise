defmodule Benefits.Users.Query do
  @moduledoc """
  The `Users` context query functions.
  It provides query functions to help the context, without
  causing too much disruption for the developers who only
  want to undestand what each function does on the context
  side without worrying about query stuff.
  """
  import Ecto.Query, warn: false

  alias Benefits.User

  def base, do: User

  @doc """
  Preloads `projects` in `User` schema.

  Returns `#Ecto.Query<>`

  ## Examples

    iex> Benefits.Products.Query.preload_products(query)
    query

  """
  def preload_products(query \\ base()), do: query |> preload(:products)
end
