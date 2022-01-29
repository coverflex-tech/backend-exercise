ExUnit.start()
Ecto.Adapters.SQL.Sandbox.mode(Benefits.Repo, :manual)
{:ok, _} = Application.ensure_all_started(:ex_machina)
