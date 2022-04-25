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
  def create_order(attrs \\ %{}) do
    benefits = add_user_to_products(attrs)

    try do
      do_db_transaction(attrs, benefits)
    rescue
      error in Postgrex.Error ->
        build_error_value(error)
    else
      transaction_results ->
        build_success_value(transaction_results)
    end
  end

  defp add_user_to_products(%{"items" => products, "user_id" => user_id}),
    do: Enum.map(products, &[user_id: user_id, product_id: &1])

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

  defp build_error_value(error) do
    {error_code, message} = do_build_error(error)

    changeset =
      %Ecto.Changeset{changes: [], data: %{}, types: []}
      |> Ecto.Changeset.add_error(error_code, message)

    {:error, changeset}
  end

  defp build_success_value({:ok, changes}), do: {:ok, changes.order}
  defp build_success_value({:error, _user_balance, changeset, _order}), do: {:error, changeset}

  defp do_build_error(%{postgres: %{code: code}}) when code == :unique_violation,
    do: {code, "The user already has a product in this order."}

  defp do_build_error(%{postgres: %{code: code}}) when code == :foreign_key_violation,
    do: {code, "There is no such product."}

  defp do_build_error(_error), do: {:unknown_error, "An unknown error has occurred."}

  defp do_db_transaction(attrs, benefits) do
    Multi.new()
    |> Multi.insert(:order, Order.changeset(%Order{}, attrs))
    |> Multi.update(:user_balance, &adjust_user_balance(&1, attrs["user_id"]))
    |> Multi.insert_all(:benefits, Benefit, &fill_out_benefits(benefits, &1))
    |> Repo.transaction()
  end

  defp fill_out_benefits(benefits, %{order: order}) do
    now = NaiveDateTime.utc_now() |> NaiveDateTime.truncate(:second)
    Enum.map(benefits, &[{:inserted_at, now}, {:updated_at, now}, {:order_id, order.id} | &1])
  end
end
