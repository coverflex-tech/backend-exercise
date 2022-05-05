defmodule Backend.Users.Services.GetUser do
  alias Backend.Users.Repository.Create
  alias Backend.Users.Repository.Get

  def call(%{"user_id" => username}) do
    case Get.call(username, orders: [:products]) do
      {:ok, user} -> {:ok, user}
      {:error, "User not found"} -> create_and_preload_orders(username)
    end
  end

  defp create_and_preload_orders(username) do
    {:ok, %{username: _username}} = Create.call(%{username: username})
    Get.call(username, orders: [:products])
  end
end
