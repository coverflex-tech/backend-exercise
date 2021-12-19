defmodule Benefits.Users do
  @moduledoc """
  The Users context.
  """

  import Ecto.Query, warn: false

  alias Benefits.Repo
  alias Benefits.Users.User

  @doc """
  Gets a single user.

  Returns nil if the User does not exist.

  ## Examples

      iex> get_user(123)
      %User{}

      iex> get_user(456)
      nil

  """
  def get_user(username) do
    Repo.get_by(User, username: username)
    |> Repo.preload([:orders])
  end

  @doc """
  Creates a user.

  ## Examples

      iex> create_user(%{field: value})
      {:ok, %User{}}

      iex> create_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end
end
