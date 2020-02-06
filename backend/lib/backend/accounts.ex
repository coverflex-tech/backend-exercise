defmodule Backend.Accounts do
  import Ecto.Query, warn: false
  alias Backend.Repo

  alias Backend.Accounts.User

  def get_user(id) do
    user = Repo.get_by(User, user_id: id)

    if user == nil do
      {:ok, new_user} = create_user(%{user_id: id})
      new_user
    else
      user
    end
  end

  def create_user(attrs \\ %{}) do
    %User{data: %{balance: 100, product_ids: []}}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  def update_user(user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end
end
