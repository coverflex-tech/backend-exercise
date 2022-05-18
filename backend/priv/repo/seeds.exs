# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
Benefits.Repo.insert!(%Benefits.Users.User{username: "rafa", balance: 500})

Benefits.Repo.insert!(%Benefits.Products.Product{name: "Netflix", price: Decimal.new("100.00")})
Benefits.Repo.insert!(%Benefits.Products.Product{name: "Amazon", price: Decimal.new("50.00")})
Benefits.Repo.insert!(%Benefits.Products.Product{name: "Hulu", price: Decimal.new("74.99")})
Benefits.Repo.insert!(%Benefits.Products.Product{name: "Disney+", price: Decimal.new("18.23")})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
