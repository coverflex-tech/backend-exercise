defmodule Coverflex.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false
  alias Coverflex.Repo

  alias Coverflex.Accounts.User

  @doc """
  Returns the list of users.

  ## Examples

      iex> list_users()
      [%User{}, ...]

  """
  def list_users do
    Repo.all(User)
  end

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

  @doc """
  Updates a user.

  ## Examples

      iex> update_user(user, %{field: new_value})
      {:ok, %User{}}

      iex> update_user(user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a user.

  ## Examples

      iex> delete_user(user)
      {:ok, %User{}}

      iex> delete_user(user)
      {:error, %Ecto.Changeset{}}

  """
  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.

  ## Examples

      iex> change_user(user)
      %Ecto.Changeset{data: %User{}}

  """
  def change_user(%User{} = user, attrs \\ %{}) do
    User.changeset(user, attrs)
  end

  @doc """
  Gets a single user by a specific field.

  ## Examples

      iex> get_user_by(id, 123)
      %User{}

      iex> get_user_by(user_id, "davidthomas")
      nil

  """
  def get_user_by(field, value), do: Repo.get_by(User, [{field, value}])

  alias Coverflex.Accounts.UserAccount

  @doc """
  Returns the list of user_accounts.

  ## Examples

      iex> list_user_accounts()
      [%UserAccount{}, ...]

  """
  def list_user_accounts do
    Repo.all(UserAccount)
  end

  @doc """
  Gets a single user_account.

  Raises `Ecto.NoResultsError` if the User account does not exist.

  ## Examples

      iex> get_user_account!(123)
      %UserAccount{}

      iex> get_user_account!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user_account!(id), do: Repo.get!(UserAccount, id)

  @doc """
  Creates a user_account.

  ## Examples

      iex> create_user_account(%{field: value})
      {:ok, %UserAccount{}}

      iex> create_user_account(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user_account(attrs \\ %{}) do
    %UserAccount{}
    |> UserAccount.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a user_account.

  ## Examples

      iex> update_user_account(user_account, %{field: new_value})
      {:ok, %UserAccount{}}

      iex> update_user_account(user_account, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_user_account(%UserAccount{} = user_account, attrs) do
    user_account
    |> UserAccount.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a user_account.

  ## Examples

      iex> delete_user_account(user_account)
      {:ok, %UserAccount{}}

      iex> delete_user_account(user_account)
      {:error, %Ecto.Changeset{}}

  """
  def delete_user_account(%UserAccount{} = user_account) do
    Repo.delete(user_account)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user_account changes.

  ## Examples

      iex> change_user_account(user_account)
      %Ecto.Changeset{data: %UserAccount{}}

  """
  def change_user_account(%UserAccount{} = user_account, attrs \\ %{}) do
    UserAccount.changeset(user_account, attrs)
  end
end
