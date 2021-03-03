defmodule Backend.Repo.Seeder do
  alias Backend.Repo
  alias Backend.{Products.Product, Users.User}

  def seed do
    Repo.insert!(%Product{
      id: "childcare_voucher",
      name: "ChildCare Voucher 500€",
      price: 500
    })

    Repo.insert!(%Product{id: "work_insurance", name: "Work Accidents Insurance", price: 0})

    Repo.insert!(%Product{id: "meal_allowance", name: "Meal Allowance", price: 12})

    for idx <- 0..18 do
      Repo.insert!(%Product{id: "product_#{idx}", name: "Product ##{idx}", price: idx * 10})
    end

    Repo.insert!(%User{
      user_id: "tester",
      balance: 1000,
      product_ids: ["childcare_voucher"]
    })
  end
end
