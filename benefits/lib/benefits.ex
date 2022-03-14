defmodule Benefits do
  @moduledoc false

  import Ecto.Query

  alias Benefits.{Repo, User, Wallet, Order, OrderProducts}

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

  def list_bought_products_ids(user_id) do
    product_ids =
      Order
      |> where([o], o.user_id == ^user_id)
      |> join(:inner, [o], po in OrderProducts, on: o.id == po.order_id)
      |> select([o, po], po.product_id)
      |> Repo.all()

    {:ok, product_ids}
  end

  defp create_wallet(user_id) do
    %{user_id: user_id, amount: initial_amount()}
    |> Wallet.changeset()
    |> Repo.insert(on_conflict: :nothing, conflict_target: :user_id, returning: true)
  end

  defp initial_amount, do: Application.get_env(:benefits, :initial_wallet_amount)
end
