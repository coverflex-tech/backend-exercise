defmodule Backend.Benefits do
  @moduledoc """
  The Benefits context. For simplicity, since this is a four-table app, it was decided to keep
  operations for all of them under just this one context.
  """
  import Ecto.Query, warn: false

  alias Ecto.Multi
  alias Backend.Repo
  alias Backend.Benefits.{Benefit, Order, Product, User}

  @doc """
  Gets a single user.

  If the user does not exist, the calling function creates it, so there is no need to raise here.

  ## Examples

      iex> get_user(123)
      %User{}

      iex> get_user(456)
      nil

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
  Creates an order. This involves other resources, so it relies on several helper functions.
  We need to check if the user has enough balance in their account for the given order; if
  they do, we deduct the total amount and create the order. We also create Benefit entries
  to represent the purchase of a given product by the corresponding user. And we check for
  errors throughout the process.

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

  #################################################################################################
  ## Benefits link a Product and a User, so we attach the user to the product name.              ##
  #################################################################################################


  defp add_user_to_products(%{"items" => products, "user_id" => user_id}),
    do: Enum.map(products, &[user_id: user_id, product_id: &1])

  #################################################################################################
  ## Check for sufficient balance and either update the User entry or add an error.              ##
  #################################################################################################

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

  #################################################################################################
  ## Transform the Postgrex error into a format suited for the changeset.                        ##
  #################################################################################################

  defp build_error_data(%{postgres: %{code: code}}) when code == :unique_violation,
    do: {:user, "The user already owns a product in this order."}

  defp build_error_data(%{postgres: %{code: code}}) when code == :foreign_key_violation,
    do: {:product, "There is no such product."}

  defp build_error_data(_error), do: {:unknown_error, "An unknown error has occurred."}

  #################################################################################################
  ## Turn a raised Postgrex error into an :error tagged tuple.                                   ##
  #################################################################################################

  defp build_error_value(error) do
    {error_code, message} = build_error_data(error)

    changeset =
      %Ecto.Changeset{changes: [], data: %{}, types: []}
      |> Ecto.Changeset.add_error(error_code, message)

    {:error, changeset}
  end

  #################################################################################################
  ## If the DB transaction returns instead of raising, process its :ok or :error result.         ##
  #################################################################################################

  defp build_success_value({:ok, changes}), do: {:ok, changes.order}
  defp build_success_value({:error, _user_balance, changeset, _order}), do: {:error, changeset}

  #################################################################################################
  ## Make all the changes to the DB.                                                             ##
  #################################################################################################

  defp do_db_transaction(attrs, benefits) do
    Multi.new()
    |> Multi.insert(:order, Order.changeset(%Order{}, attrs))
    |> Multi.update(:user_balance, &adjust_user_balance(&1, attrs["user_id"]))
    |> Multi.insert_all(:benefits, Benefit, &fill_out_benefits(benefits, &1))
    |> Repo.transaction()
  end

  #################################################################################################
  ## Provide the benefit with information about its order. The Multi strategy we used also means ##
  ## we must provide timestamps ourselves.                                                       ##
  #################################################################################################

  defp fill_out_benefits(benefits, %{order: order}) do
    now = NaiveDateTime.utc_now() |> NaiveDateTime.truncate(:second)
    Enum.map(benefits, &[{:inserted_at, now}, {:updated_at, now}, {:order_id, order.id} | &1])
  end
end
