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
alias Coverflex.Orders.Order
alias Coverflex.Orders.OrderItem
alias Coverflex.Repo
alias Coverflex.Products.Product

Repo.insert!(%User{
  user_id: "richardfeynman"
})

user1 =
  Repo.insert!(%User{
    user_id: "alanturing"
  })

user2 =
  Repo.insert!(%User{
    user_id: "vonneumann"
  })

product1 =
  Repo.insert!(%Product{
    name: "product#{System.unique_integer([:positive])}",
    price: 100
  })

product2 =
  Repo.insert!(%Product{
    name: "product#{System.unique_integer([:positive])}",
    price: 200
  })

order1 =
  Repo.insert!(%Order{
    user_id: user1.id,
    total: 100
  })

order2 =
  Repo.insert!(%Order{
    user_id: user2.id,
    total: 200
  })

Repo.insert!(%OrderItem{
  order_id: order1.id,
  product_id: product1.id,
  price: 100
})

Repo.insert!(%OrderItem{
  order_id: order2.id,
  product_id: product2.id,
  price: 200
})
