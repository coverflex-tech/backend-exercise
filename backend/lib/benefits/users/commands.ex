defmodule Benefits.Users.Commands do
  @moduledoc """
  Commands that interact with the user schema, producing side-effects.
  """

  alias Benefits.Repo
  alias Benefits.Users.User
  alias Ecto.Changeset

  @doc """
  Creates an user with the default balance
  """
  @spec create_user(params :: map) :: {:ok, User.t()} | {:error, Changeset.t()}
  def create_user(params) do
    params
    |> User.changeset()
    |> Repo.insert()
  end
end
