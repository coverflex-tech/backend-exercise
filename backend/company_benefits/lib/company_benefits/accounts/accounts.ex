defmodule CompanyBenefits.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false
  alias CompanyBenefits.Repo

  alias CompanyBenefits.Accounts.{User, UserContext}

  @doc """
  Logs in an user.
  Creates if not exists
  """
  def login(username) do
    with %User{} = user <- UserContext.get_user_by_username(username) do
      {:ok, user}
    else
      _ ->
        UserContext.create_user(%{
          username: username,
          balance: 0
        })
    end
  end
end
