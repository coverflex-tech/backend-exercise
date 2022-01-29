# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Benefits.Repo.insert!(%Benefits.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
alias Benefits.Product
alias Benefits.Repo
alias Benefits.User

Repo.insert!(%User{username: "admin", balance: 1000.0})
Repo.insert!(%User{username: "bernardes", balance: 50.0})
Repo.insert!(%Product{identifier: "netflix", name: "Netflix Subscription", price: 30.0})
Repo.insert!(%Product{identifier: "spotify", name: "Spotify Subscription", price: 60.5})
Repo.insert!(%Product{identifier: "amazon prime", name: "Amazon Prime Subscription", price: 10.0})
Repo.insert!(%Product{identifier: "surf with Tiago", name: "Surf with Tiago", price: 0.0})
