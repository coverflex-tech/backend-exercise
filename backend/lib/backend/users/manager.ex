defmodule Backend.Users.Manager do
  alias Backend.Repo
  alias Backend.Users.{Order, User}
  alias Ecto.Multi

  @moduledoc """
  User manager module to handle user related operations:
   - GET_BY
   - NEW
   - ORDER
  """

  @callback get(user_id :: binary()) :: {:ok, User.t()} | {:error, :invalid_user_id}
  @callback add(user_id :: binary()) :: {:ok, User.t()} | {:error, reason :: term()}
  @callback order(user_id :: binary(), list(binary()), total :: integer()) ::
              {:ok, Order.t()}
              | {:error,
                 :invalid_user_id
                 | :insufficient_balance
                 | :products_already_purchased}

  @default_user_balance Application.compile_env!(:backend, [
                          :user,
                          :default_balance
                        ])

  def get(user_id) do
    case Repo.get(User, user_id) do
      nil -> {:error, :invalid_user_id}
      user -> {:ok, user}
    end
  end

  def add(user_id) do
    Repo.insert(%User{user_id: user_id, balance: @default_user_balance})
  end

  # There is the assumption that `items` have already been pre-validated
  def order(user_id, items, total) do
    with {:ok, user} <- get(user_id),
         {:ok, %{order: order, user: _}} <- make_order(user, items, total) do
      {:ok, order}
    else
      {:error, _, changeset, _} ->
        {:error,
         changeset.errors
         |> Enum.at(0)
         |> elem(1)
         |> elem(0)
         |> String.to_atom()}

      error ->
        error
    end
  end

  defp make_order(%User{user_id: user_id} = user, items, total) do
    order = %Order{user_id: user_id, items: items, total: total}

    Multi.new()
    |> Multi.update(:user, User.order(user, items, total))
    |> Multi.insert(:order, order)
    |> Repo.transaction()
  end
end
