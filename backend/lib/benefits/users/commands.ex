defmodule Benefits.Users.Commands do
  @moduledoc """
  Commands that interact with the user schema, producing side-effects.
  """

  alias Benefits.Repo
  alias Benefits.Users.User

  @doc """
  Creates an user with the default balance
  """
  @spec create_user!(username :: String.t()) ::
          User.t()
  def create_user!(username) do
    %{username: username}
    |> User.changeset()
    |> Repo.insert!()
  end

  @doc """
  Decreases user balance
  """
  @spec decrease_user_balance!(user :: User.t(), value :: integer()) ::
          User.t() | no_return()
  def decrease_user_balance!(user, value) do
    new_balance = user.balance - value

    user
    |> User.changeset(%{balance: new_balance})
    |> Repo.update!()
  end
end
