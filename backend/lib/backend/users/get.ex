defmodule Backend.Users.Get do
  alias Backend.Users.Schemas.User
  alias Backend.Repo

  @spec call(String.t()) :: User.t() | :not_found
  def call(user_id) do
    case get_by_id(user_id) do
      nil -> :not_found
      %User{} = user -> user
    end
  end

  defp get_by_id(user_id) do
    Repo.get(User, user_id)
    |> Repo.preload(:order_items)
  end
end
