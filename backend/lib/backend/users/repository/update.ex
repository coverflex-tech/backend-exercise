defmodule Backend.Users.Repository.Update do
  alias Backend.Repo
  alias Backend.Users.Changeset
  alias Backend.Users.User

  def call(id, params) do
    case Repo.get(User, id) do
      %User{} = user ->
        user
        |> Changeset.changeset(params)
        |> Repo.update()

      nil ->
        {:error, "User not found"}
    end
  end
end
