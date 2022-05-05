defmodule Backend.Users.Repository.Create do
  alias Backend.Repo
  alias Backend.Users.Changeset

  def call(params) do
    params
    |> Changeset.changeset()
    |> Repo.insert()
  end
end
