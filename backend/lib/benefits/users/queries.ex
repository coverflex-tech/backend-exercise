defmodule Benefits.Users.Queries do
  @moduledoc """
  Queries the user schema.
  """

  import Ecto.Query

  alias Benefits.Repo
  alias Benefits.Users.User

  @doc """
  Retrieves an user.

  Accepts a :lock_for_update? option that defines if
  we should lock the row for updating the user balance.
  """
  @spec get_user_by_username(username :: String.t(), opts :: Keyword.t()) ::
          {:error, :user_not_found} | {:ok, User.t()}
  def get_user_by_username(username, opts \\ []) do
    lock_for_update = Keyword.get(opts, :lock_for_update, false)

    User
    |> where(username: ^username)
    |> lock?(lock_for_update)
    |> Repo.one()
    |> case do
      nil -> {:error, :user_not_found}
      user -> {:ok, user}
    end
  end

  @doc """
  Checks if a given user has enough balance to purchase
  a given list of products.

  You should only call this function inside a transaction
  after fetching the user with lock_for_update?: true.
  """
  @spec enough_balance?(User.t(), [Product.t()]) ::
          {:ok, integer()} | {:error, :insufficient_balance}
  def enough_balance?(%{balance: balance}, products) do
    total_price = Enum.reduce(products, 0, &(&1.price + &2))

    if total_price <= balance,
      do: {:ok, total_price},
      else: {:error, :insufficient_balance}
  end

  defp lock?(query, false = _should_lock?), do: query

  defp lock?(query, true = _should_lock?) do
    lock(query, "FOR UPDATE")
  end
end
