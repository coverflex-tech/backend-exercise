defmodule Backend.Users.GetOrCreate do
  @moduledoc """
  Module reponsible to get a User and create if dons't exists
  """
  alias Backend.Users.Create
  alias Backend.Users.Get
  alias Backend.Users.Schemas.User

  @spec call(%{
          required(:id) => String.t()
        }) :: {:ok, User.t()} | {:error, Ecto.Changeset.t()}
  def call(%{id: user_id}) do
    case Get.call(user_id) do
      %User{} = user -> {:ok, user}
      :not_found -> Create.call(%{id: user_id})
    end
  end
end
