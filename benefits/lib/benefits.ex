defmodule Benefits do
  @moduledoc false

  import Ecto.Query

  alias Benefits.{Repo, User}

  def get_or_create_user(username) when is_binary(username) do
    %{username: username}
    |> User.changeset()
    |> Repo.insert(on_conflict: :nothing, conflict_target: :username, returning: true)
  end
end
