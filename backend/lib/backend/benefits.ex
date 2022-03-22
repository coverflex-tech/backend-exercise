defmodule Backend.Benefits do
  @moduledoc """
  The Benefits context.
  """

  import Ecto.Query, warn: false
  alias Backend.Repo

  alias Backend.Benefits.{Product, User}

  @default_balance 500_00

  @doc """
  Gets a single user by username, or creates a new with default values.
  """
  def get_or_create_user(%{username: username}) do
    case Repo.get_by(User, username: username) do
      nil -> create_user(%{username: username, balance: @default_balance})
      user -> {:ok, user}
    end
  end

  defp create_user(attrs) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Returns the list of products.
  """
  def list_products do
    Repo.all(Product)
  end

  @doc """
  Creates a product.
  """
  def create_product(attrs \\ %{}) do
    %Product{}
    |> Product.changeset(attrs)
    |> Repo.insert()
  end
end
