defmodule Backend.Users.Update do
  alias Backend.Users.Schemas.User
  alias Backend.Repo

  @spec call(
          Backend.Repo.t(),
          User.t(),
          map()
        ) :: {:ok, User.t()} | {:error, Ecto.Changeset.t()}
  def call(repo, %User{} = user, params) do
    case update(repo, user, params) do
      {:ok, user} ->
        user = Map.put(user, :order_items, [])
        {:ok, user}

      error ->
        error
    end
  end

  @spec call(
          User.t(),
          map()
        ) :: {:ok, User.t()} | {:error, Ecto.Changeset.t()}
  def call(%User{} = user, params) do
    call(Repo, user, params)
  end

  defp update(repo, user, params) do
    user
    |> User.changeset(params)
    |> repo.update()
  end
end
