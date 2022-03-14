defmodule Benefits do
  @moduledoc false

  alias Benefits.{Repo, User, Wallet}

  @doc """
  Returns a user with the given username, creating it if it does not exist
  """
  @spec get_or_create_user(username :: String.t()) :: {:ok, User.t()}
  def get_or_create_user(username) when is_binary(username) do
    Repo.transaction(fn ->
      {:ok, user} =
        case Repo.get_by(User, username: username) do
          nil -> create_user(username)
          user -> {:ok, User.load_bought_product_ids(user)}
        end

      {:ok, wallet} =
        case Repo.get_by(Wallet, user_id: user.id) do
          nil -> create_wallet(user.id)
          wallet -> {:ok, wallet}
        end

      Map.put(user, :wallet, wallet)
    end)
  end

  defp create_user(username) do
    %{username: username}
    |> User.changeset()
    |> Repo.insert(on_conflict: :nothing, conflict_target: :username, returning: true)
  end

  defp create_wallet(user_id) do
    %{user_id: user_id, amount: initial_amount()}
    |> Wallet.changeset()
    |> Repo.insert(on_conflict: :nothing, conflict_target: :user_id, returning: true)
  end

  defp initial_amount, do: Application.get_env(:benefits, :initial_wallet_amount)
end
