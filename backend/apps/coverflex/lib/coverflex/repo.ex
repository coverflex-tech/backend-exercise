defmodule Coverflex.Repo do
  use Ecto.Repo,
    otp_app: :coverflex,
    adapter: Ecto.Adapters.Postgres
end
