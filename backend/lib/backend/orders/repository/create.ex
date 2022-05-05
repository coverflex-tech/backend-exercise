defmodule Backend.Orders.Repository.Create do
  alias Backend.Orders.Changeset
  alias Backend.Repo

  def call(params) do
    params
    |> Changeset.changeset()
    |> Repo.insert()
  end
end
