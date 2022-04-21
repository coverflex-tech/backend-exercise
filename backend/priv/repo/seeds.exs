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

Backend.Repo.delete_all(Backend.Benefits.Product)

netflix = %{id: "netflix", name: "Netflix", price: 7599}
spa = %{id: "spa", name: "Spa Treatment", price: 2999}
gym = %{id: "gym", name: "Gym Membership", price: 2999}
healthcare = %{id: "healthcare", name: "Healthcare - Basic Plan", price: 11350}
dental = %{id: "dental", name: "Healthcare - Dental Plan", price: 3700}
optical = %{id: "optical", name: "Healthcare - Vision Plan", price: 1469}
limo = %{id: "limo", name: "Limousine ride to work every day", price: 47999}

[netflix, spa, gym, healthcare, dental, optical, limo]
|> Enum.map(&struct(Backend.Benefits.Product, &1))
|> Enum.each(&Backend.Repo.insert!(&1))
