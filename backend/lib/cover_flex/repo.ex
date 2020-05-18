defmodule CoverFlex.Repo do
  use Ecto.Repo,
    otp_app: :cover_flex,
    adapter: Ecto.Adapters.Postgres
end
