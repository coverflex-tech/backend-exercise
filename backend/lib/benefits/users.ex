defmodule Benefits.Users do
  @moduledoc """
  The Users context.
  """

  import Ecto.Query, warn: false
  alias Benefits.Repo

  alias Benefits.Users.User

  @doc """
  Gets a single user.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_user!(123)
      %User{}

      iex> get_user!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user!(id), do: Repo.get!(User, id)
  def get_user(id), do: Repo.get(User, id)

  def find_or_create_user(user_id) do
    case get_user(user_id) do
      nil ->
        create_user(%{user_id: user_id})
        |> then(fn {:ok, user} -> user end)

      user ->
        user
    end
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
  end

end
