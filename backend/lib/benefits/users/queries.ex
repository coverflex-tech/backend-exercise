defmodule Benefits.Users.Queries do
  @moduledoc """
  Queries the user schema.
  """

  alias Benefits.Repo
  alias Benefits.Users.User

  import Ecto.Query

  @doc """
  Retrieves an user.

  Accepts a :lock_for_update? option that defines if
  we should lock the row for updating the user balance.
  """
  @spec get_user(params :: %{user_id: String.t()}, opts :: Keyword.t()) ::
          {:not_found, String.t()} | {:ok, User.t()}
  def get_user(%{user_id: username}, opts \\ []) do
    lock_for_update = Keyword.get(opts, :lock_for_update, false)

    User
    |> where(username: ^username)
    |> lock?(lock_for_update)
    |> Repo.one()
    |> case do
      nil -> {:not_found, username}
      user -> {:ok, user}
    end
  end

  defp lock?(query, false = _should_lock?), do: query

  defp lock?(query, true = _should_lock?) do
    lock(query, "FOR UPDATE")
  end
end
