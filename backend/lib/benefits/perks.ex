defmodule Benefits.Perks do
  @moduledoc """
  The Perks context.
  """

  import Ecto.Query, warn: false

  alias Ecto.Multi
  alias Benefits.Repo
  alias Benefits.Accounts.User
  alias Benefits.Perks.{Order, OrderLine, Product}

  @doc """
  Returns the list of products.

  ## Examples

      iex> list_products()
      [%Product{}, ...]

  """
  def list_products do
    Repo.all(Product)
  end

  @doc """
  Creates a product.

  ## Examples

      iex> create_product(%{field: value})
      {:ok, %Product{}}

      iex> create_product(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_product(attrs \\ %{}) do
    %Product{}
    |> Product.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Creates an order.

  ## Examples

      iex> create_order(%{field: value})
      {:ok, %Order{}}

      iex> create_order(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_order(products_identifiers, user_id) do
    case create_order_transaction(products_identifiers, user_id) do
      {:ok, changeset} ->
        {:ok, %{
          order_id: changeset.order.id,
          total: changeset.total,
          items: changeset.identifiers
        }}

      {:error, :products_existence, message, _changes} -> {:error, message}

      {:error, :update_user, _changeset, _changes} -> {:error, "insufficient_balance"}

      {:error, _op, changeset, _changes} ->
        {:error, Keyword.get(changeset.errors, :user_id) |> elem(0)}
    end
  end

  # Creates a transaction that updates correctly all the data entities
  # with a transaction built with the Multi structure
  @spec create_order_transaction(list(String.t()), String.t()) ::
          {:ok, any()}
          | {:error, any()}
          | {:error, Ecto.Multi.name(), any(), %{required(Ecto.Multi.name()) => any()}}
  defp create_order_transaction(products_identifiers, user_id) do
    Multi.new()
    # put the :identifiers field in the multi
    |> Multi.put(:identifiers, Enum.uniq(products_identifiers))
    # fetch and attach :products field from the identifiers in the multi
    |> Multi.run(:products, fn repo, %{identifiers: identifiers} ->
      {:ok, fetch_products_by_identifiers(repo, identifiers)}
    end)
    # check if the identifiers actually identify products
    |> Multi.run(:products_existence, fn _repo, multi ->
      check_products_existence(multi.identifiers, multi.products)
    end)
    # get the user_id corresponding user
    |> Multi.run(:user, fn repo, _multi ->
      case repo.get_by(User, user_id: user_id) do
        nil -> {:error, "Inexistent User"}
        %User{} = user -> {:ok, user}
      end
    end)
    # calculate the total to subtract to balance
    |> Multi.run(:total, fn _repo, %{products: products} ->
      {:ok, Enum.reduce(products, 0, &(&1.price + &2))}
    end)
    # Update User balance
    |> Multi.update(:update_user, fn %{user: user, total: total} ->
      User.changeset(user, %{balance: user.balance - total})
    end)
    # Insert a new order
    |> Multi.insert(:order, fn %{user: user, total: total} ->
      Order.changeset(%Order{}, %{user_id: user.id, total: total})
    end)
    # Insert order lines
    |> Multi.merge(fn %{user: user, order: order, products: products} ->
      insert_order_lines(user, order, products)
    end)
    |> Repo.transaction()
  end

  # Given a list of identifiers, returns the products that match those list.
  @spec fetch_products_by_identifiers(Ecto.Repo.t(), list(String.t())) :: list(Product.t())
  defp fetch_products_by_identifiers(repo, identifiers) when is_list(identifiers) do
    Product
    |> where([p], p.identifier in ^identifiers)
    |> repo.all()
  end

  # Checks if the list of identifiers has the same size as the list of products
  # Also checks if the list of identifiers is not empty
  @spec check_products_existence(list(String.t()), list(Product.t())) ::
          {:ok, true} | {:error, String.t()}
  defp check_products_existence(identifiers, products)
       when length(identifiers) == length(products) and length(identifiers) > 0,
       do: {:ok, true}

  defp check_products_existence(_identifiers, _products), do: {:error, "products_not_found"}

  # Creates a Multi structure to insert multiple order lines.
  @spec insert_order_lines(User.t(), Order.t(), list(Product.t())) :: Multi.t()
  defp insert_order_lines(user, order, products) do
    Enum.reduce(products, Multi.new(), fn product, multi ->
      Multi.insert(multi, :"#{product.identifier}", fn _ ->
        OrderLine.changeset(%OrderLine{}, %{
          user_id: user.id,
          order_id: order.id,
          product_id: product.id
        })
      end)
    end)
  end
end
