defmodule Backend.Users.Get do
  alias Backend.Users.Schemas.User
  alias Backend.Repo

  @spec call(Backend.Repo.t(), String.t()) :: User.t() | :not_found
  def call(repo, user_id) do
    case get_by_id(repo, user_id) do
      nil -> :not_found
      %User{} = user -> user
    end
  end

  @spec call(String.t()) :: User.t() | :not_found
  def call(user_id) do
    call(Backend.Repo, user_id)
  end

  defp get_by_id(repo, user_id) do
    repo.get(User, user_id)
    |> Repo.preload(:order_items)
  end
end
