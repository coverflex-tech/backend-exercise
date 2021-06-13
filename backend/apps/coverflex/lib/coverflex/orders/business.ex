import Ecto.Query, warn: false

alias Coverflex.Products.Product
alias Coverflex.Accounts.User
alias Ecto.Multi
alias Coverflex.Repo

defmodule Coverflex.Orders.Business do
  def validate_if_user_has_enough_balance_to_buy_products(multi, user_id, products) do
    multi
    |> Multi.run(
      :user,
      fn _repo, _ ->
        user = Repo.get_by(User, user_id: user_id) |> Repo.preload([:account])
        {:ok, user}
      end
    )
    |> Multi.run(
      :products_price,
      fn _repo, _ ->
        total_price = from(p in Product, where: p.id in ^products) |> Repo.aggregate(:sum, :price)

        {:ok, total_price}
      end
    )
    |> Multi.run(
      :check_balance,
      fn _repo, %{products_price: products_price, user: user} ->
        case user.account.balance >= products_price do
          true -> {:ok, :ok}
          false -> {:error, "you do not have enough balance to buy the selected products"}
        end
      end
    )
  end
end
