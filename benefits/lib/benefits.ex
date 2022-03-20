defmodule Benefits do
  @moduledoc """
  Benefits main context
  """

  import Ecto.Query

  alias Benefits.{Repo, User, Wallet, CreateOrder, Order, OrderProduct, Product}

  defdelegate create_order(input), to: CreateOrder, as: :perform

  @doc """
  Get or creates a new user

  If there is no user with the given username, a new one will be
  created, receiving a wallet. Note that the new wallet has the
  amount set on the `config :benefits, :initial_wallet_amount`
  """
  @spec get_or_create_user(username :: String.t()) :: {:ok, User.t()}
  def get_or_create_user(username) when is_binary(username) do
    Repo.transaction(fn ->
      {:ok, user} =
        %{username: username}
        |> User.changeset()
        |> Repo.insert(
          on_conflict: {:replace, [:username]},
          conflict_target: :username,
          returning: true
        )

      {:ok, wallet} =
        case Repo.get_by(Wallet, user_id: user.id) do
          nil -> create_wallet(user.id)
          wallet -> {:ok, wallet}
        end

      Map.put(user, :wallet, wallet)
    end)
  end

  defp create_wallet(user_id) do
    %{user_id: user_id, amount: initial_amount()}
    |> Wallet.changeset()
    |> Repo.insert(on_conflict: :nothing, conflict_target: :user_id, returning: true)
  end

  defp initial_amount, do: Application.get_env(:benefits, :initial_wallet_amount)

  @doc "Lists all products"
  @spec list_products() :: {:ok, list(Product.t())}
  def list_products do
    {:ok, Repo.all(Product)}
  end

  @doc "Returns the id of all products previously purchased by a user"
  @spec list_bought_products_ids(user_id :: String.t()) :: list(String.t())
  def list_bought_products_ids(user_id) do
    product_ids =
      Order
      |> where([o], o.user_id == ^user_id)
      |> join(:inner, [o], po in OrderProduct, on: o.id == po.order_id)
      |> select([o, po], po.product_id)
      |> Repo.all()

    {:ok, product_ids}
  end
end
