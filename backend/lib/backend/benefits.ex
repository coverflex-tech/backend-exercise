defmodule Backend.Benefits do
  @moduledoc """
  The Benefits context.
  """

  import Ecto.Query, warn: false
  alias Ecto.Multi
  alias Backend.Repo
  alias Backend.Benefits.{Benefit, Order, Product, User}

  @doc """
  Gets a single user.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_user!(123)
      %User{}

      iex> get_user!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user(user_id), do: Repo.get(User, user_id)

  @doc """
  Creates a user.

  ## Examples

      iex> create_user(%{field: value})
      {:ok, %User{}}

      iex> create_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a user.

  ## Examples

      iex> update_user(user, %{field: new_value})
      {:ok, %User{}}

      iex> update_user(user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Returns the list of products.

  ## Examples

      iex> list_products()
      [%Product{}, ...]

  """
  def list_products, do: Repo.all(Product)

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
      {:error, ...}

  """
  def create_order(attrs = %{"items" => products, "user_id" => user_id} \\ %{}) do
    benefits =
      products
      |> Enum.map(&[user_id: user_id, product_id: &1])

    result =
      Multi.new()
      |> Multi.insert(:order, Order.changeset(%Order{}, attrs))
      |> Multi.update(:user_balance, &adjust_user_balance(&1, user_id))
      |> Multi.insert_all(:benefits, Benefit, &add_order_id(benefits, &1))
      |> Repo.transaction()

    case result do
      {:ok, changes} ->
        {:ok, changes.order}

      {:error, _user_balance, changeset, _order} ->
        {:error, changeset}
    end
  end

  defp add_order_id(benefits, %{order: order}) do
    now = NaiveDateTime.utc_now() |> NaiveDateTime.truncate(:second)
    Enum.map(benefits, &[{:inserted_at, now}, {:updated_at, now}, {:order_id, order.id} | &1])
  end

  defp adjust_user_balance(%{order: order}, user_id) do
    user = Repo.get!(User, user_id)

    case user.balance - order.total do
      new_balance when new_balance >= 0 ->
        Ecto.Changeset.change(user, balance: new_balance)

      _insufficient_balance ->
        user
        |> Ecto.Changeset.cast(Map.from_struct(user), [:user_id, :balance])
        |> Ecto.Changeset.add_error(:user, "Insufficient balance")
    end
  end
end
