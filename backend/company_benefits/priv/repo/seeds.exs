# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     CompanyBenefits.Repo.insert!(%CompanyBenefits.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias CompanyBenefits.Products.ProductContext

products = [
  %{
    identifier: "netflix",
    name: "Netflix",
    price: 40
  },
  %{
    identifier: "spotify",
    name: "Spotify",
    price: 40
  },
  %{
    identifier: "worten",
    name: "Worten 20% Discount",
    price: 20
  },
  %{
    identifier: "tap",
    name: "TAP Airlines 12% Discount",
    price: 60
  },
  %{
    identifier: "health-insurance",
    name: "Health Insurance",
    price: 250
  },
  %{
    identifier: "equipment-insurance",
    name: "Personal Equipment Insurance",
    price: 60
  }
]

Enum.each(products, fn product -> ProductContext.create_product(product) end)
