# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Coverflex.Repo.insert!(%Coverflex.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias Coverflex.Accounts.User
alias Coverflex.Repo

Repo.insert!(%User{
  user_id: "richardfeynman"
})

Repo.insert!(%User{
  user_id: "alanturing"
})

Repo.insert!(%User{
  user_id: "vonneumann"
})
