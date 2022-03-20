if Mix.env() != :test do
  alias Benefits.{Product, Repo}

  now = NaiveDateTime.utc_now() |> NaiveDateTime.truncate(:second)

  products_to_insert = [
    %{name: "Netflix", price: Money.parse!("50.00"), inserted_at: now, updated_at: now},
    %{name: "Iphone", price: Money.parse!("2500.00"), inserted_at: now, updated_at: now},
    %{name: "Apple Watch", price: Money.parse!("500.50"), inserted_at: now, updated_at: now}
  ]

  Repo.insert_all(Product, products_to_insert)
end
