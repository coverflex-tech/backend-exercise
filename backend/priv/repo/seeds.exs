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
alias Backend.Benefits.Products.Product
alias Backend.Repo

Repo.insert!(Product.changeset(%Product{}, %{name: "Netflix", price: 4200, string_id: "netflix"}))

Repo.insert!(
  Product.changeset(%Product{}, %{name: "Amazon Prime", price: 900, string_id: "amazon_prime"})
)

Repo.insert!(
  Product.changeset(%Product{}, %{
    name: "Very Expensive Service",
    price: 900_000,
    string_id: "expensive"
  })
)
