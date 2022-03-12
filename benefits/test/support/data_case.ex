defmodule Benefits.DataCase do
  @moduledoc false

  use ExUnit.CaseTemplate

  using do
    quote do
      import Benefits.Factory

      alias Benefits.Repo
    end
  end

  setup tags do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Benefits.Repo)

    unless tags[:async] do
      Ecto.Adapters.SQL.Sandbox.mode(Benefits.Repo, {:shared, self()})
    end

    :ok
  end
end
