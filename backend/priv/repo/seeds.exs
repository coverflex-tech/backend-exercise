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

alias Benefits.Repo
alias Benefits.Products.Product

products = [
  %{name: "Stinger missiles", price: 1000},
  %{name: "T-Rex", price: 10000},
  %{name: "M345 MECHA", price: 300_000}
]

products
|> Enum.map(
  &Map.merge(&1, %{
    inserted_at: NaiveDateTime.utc_now(),
    updated_at: NaiveDateTime.utc_now()
  })
)
|> then(fn products ->
  Repo.insert_all(Product, products)
end)
