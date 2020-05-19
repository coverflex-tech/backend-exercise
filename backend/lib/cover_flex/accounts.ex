defmodule CoverFlex.Accounts do
  @moduledoc """
  Accounts is the context that deals with users and user management.
  """
  alias CoverFlex.Repo
  alias CoverFlex.Accounts.User

  @spec create_user(Map.t()) :: {:ok, Ecto.Schema.t()} | {:error, Ecto.Changeset.t()}
  @doc """
  Creates and inserts a user with the given `attrs` map through a changeset.

  Returns {:ok, user} on success, or {:error, changeset} on failure.

  ## Examples

      iex> create_user(%{id: "doesnotexist"})
      {:ok, %User{id: "doesnotexist", balance: 500}}

      iex> create_user(%{id: "oldschooluser"})
      {:error, Ecto.Changeset{...}} # user already exists, etc

  """
  def create_user(attrs \\ %{}) do
    User.changeset(%User{}, attrs)
    |> Repo.insert()
  end

  @spec ensure_user(String.t()) :: %User{}
  @doc """
  Ensures a user with `id` exists, either by fetching the existing one, or
  creating a new one and returning it if it doesn't.

  ## Examples

      iex> ensure_user("oldschooluser")
      %User{id: "oldschooluser", balance: 20}

      iex> ensure_user("doesnotexist")
      %User{id: "doesnotexist", balance: 500}

  """
  def ensure_user(id) do
    case Repo.get(User, id) do
      nil ->
        {:ok, user} = create_user(%{id: id})
        user
      %User{} = user ->
        user
    end
  end

  @spec bill_user(User.t(), integer()) :: User.t()
  def bill_user(%User{} = user, ammount) do
    new_balance = user.balance - ammount

    Ecto.Changeset.change(user, balance: new_balance)
    |> Repo.update!()
  end
end
