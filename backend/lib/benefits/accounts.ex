defmodule Benefits.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false
  alias Benefits.Repo

  alias Benefits.Accounts.User

  @doc """
  Gets a single user using the user_id field.

  Returns `nil` if no result was found. Raises if more than one entry.

  ## Examples

      iex> get_user("user1")
      %User{}

      iex> get_user("inexistent")
      nil

  """
  def get_user(user_id) do
    Repo.get_by(User, user_id: user_id)
    |> Repo.preload(:products)
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
    |> (&(
      case &1 do
        {:ok, user} -> {:ok, Repo.preload(user, :products)}
        error -> error
      end
    )).()
  end
end
