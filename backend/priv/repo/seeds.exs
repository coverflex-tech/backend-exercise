# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Backend.Repo.insert!(%Backend.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

[
  %Backend.Products.Schemas.Product{
    id: "netflix",
    name: "Netflix",
    price: Decimal.new("79.90")
  },
  %Backend.Products.Schemas.Product{
    id: "spotify",
    name: "Spotify",
    price: Decimal.new("29.90")
  },
  %Backend.Products.Schemas.Product{
    id: "amazon_prime_video",
    name: "Amazon Prime Video",
    price: Decimal.new("19.90")
  }
]
|> Enum.each(&Backend.Repo.insert!/1)
