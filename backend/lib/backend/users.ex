defmodule Backend.Users do
  @moduledoc """
  User Context to expose User Api and common functions to Users
  """
  alias Backend.Users.GetOrCreate

  defdelegate get_or_create(params), to: GetOrCreate, as: :call
end
