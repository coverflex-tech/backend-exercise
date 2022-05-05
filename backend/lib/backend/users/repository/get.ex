defmodule Backend.Users.Repository.Get do
  alias Backend.Repo
  alias Backend.Users.User

  def call(username, requested_relationships \\ []) do
    case Repo.get(User, username) do
      %User{} = user -> {:ok, Repo.preload(user, requested_relationships)}
      nil -> {:error, "User not found"}
    end
  end
end
