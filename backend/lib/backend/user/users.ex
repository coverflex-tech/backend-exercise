defmodule Benefits.Users do
  @moduledoc """
  The `Users` context.
  It provides direct actions with `User` schema and `users` table.
  """
  alias Benefits.Repo
  alias Benefits.User
  alias Benefits.Users.Query

  @doc """
  Gets an user by his `username`.
  If it doesn't finds one, creates it.

  Returns `{:ok, %User{}}` or `{:error, changeset}` or `{:error, "not_allowed"}`

  ### Examples

    iex> Benefits.Users.get_by_username("")
    {:error, "not_allowed"}

    iex> Benefits.Users.get_by_username("existing_username")
    {:ok, %User{username: "an_existing_username"}}

    iex> Benefits.Users.get_by_username("non_existing_username")
    {:ok, %User{username: "non_existing_username"}}

    iex> Benefits.Users.get_by_username("non_existing_username")
    {:error, changeset}

  """
  def get_by_username(username)
  def get_by_username(username) when username in ["", nil], do: {:error, "not_allowed"}

  def get_by_username(username) do
    User
    |> Query.preload_products()
    |> Repo.get_by(username: username)
    |> case do
      nil -> create(username)
      %User{} = user -> {:ok, user}
    end
  end

  #
  # Creates a new user with given `username`
  #
  defp create(username), do: %User{} |> User.changeset(%{username: username}) |> Repo.insert()

  @doc """
  Updates an `user` with new `attrs`

  Returns `{:ok, %User{}}` or `{:error, changeset}`

  ### Examples

    iex> Benefits.Users.update(%User{}, %{balance: 5})
    {:ok, %User{balance: 5}}

    iex> Benefits.Users.update(%User{}, %{balance: true})
    {:error, changeset}

  """
  def update(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end
end
