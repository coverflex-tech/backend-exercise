defmodule Backend.Users.Create do
  @moduledoc """
  Module used to create a User
  """
  alias Backend.Users.Schemas.User
  alias Backend.Repo

  @inital_balance Decimal.new("100.00")

  @spec call(%{
          required(:id) => String.t()
        }) :: {:ok, User.t()} | {:error, Ecto.Changeset.t()}
  def call(%{id: user_id}) do
    case create(user_id) do
      {:ok, user} ->
        user = Map.put(user, :order_items, [])
        {:ok, user}

      error ->
        error
    end
  end

  defp create(user_id) do
    %User{}
    |> User.changeset(%{id: user_id, balance: @inital_balance})
    |> Repo.insert()
  end
end
