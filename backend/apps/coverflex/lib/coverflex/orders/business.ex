import Ecto.Query, warn: false

alias Coverflex.Products.Product
alias Coverflex.Accounts.User
alias Coverflex.Orders.{Order, OrderItem}
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
      :products,
      fn _repo, _ ->
        products = from(p in Product, where: p.id in ^products) |> Repo.all()

        {:ok, products}
      end
    )
    |> Multi.run(
      :products_price,
      fn _repo, %{products: products} ->
        # I choose reduce to avoid another query to aggregate the sum of prices
        total_price = Enum.reduce(products, 0, fn product, acc -> acc + product.price end)

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

  def create_order(multi) do
    multi
    |> Multi.insert(
      :order,
      fn %{products_price: products_price, user: user} ->
        Order.changeset(%Order{}, %{total: products_price})
        |> Ecto.Changeset.put_assoc(:user, user)
      end
    )
  end

  def create_products_for_order(multi) do
    multi
    |> Multi.insert(
      :order_items,
      fn %{order: order, products: products} ->
        # TODO: Use map to create changesets https://hexdocs.pm/ecto/Ecto.Multi.html#insert_all/5-example
        product = hd(products)

        OrderItem.changeset(%OrderItem{}, %{
          price: product.price
        })
        |> Ecto.Changeset.put_assoc(:product, product)
        |> Ecto.Changeset.put_assoc(:order, order)
      end
    )
  end

  def populate_products_previously_purchased(multi) do
    multi
    |> Multi.run(
      :products_previously_purchased,
      fn _repo, %{user: user} ->
        products_bough =
          from(p in Product,
            join: oi in OrderItem,
            on: oi.product_id == p.id,
            join: o in Order,
            on: o.id == oi.order_id,
            join: u in User,
            on: u.id == o.user_id,
            where: u.id == ^user.id
          )
          |> Repo.all()

        {:ok, products_bough}
      end
    )
  end

  def validate_if_user_already_purchased_any_product_previously(multi) do
    multi
    |> Multi.run(
      :at_least_one_product_was_previously_purchased?,
      fn _repo, %{products_previously_purchased: products_previously_purchased} ->
        case length(products_previously_purchased) do
          0 -> {:ok, false}
          _ -> {:error, "at least one of your selected products was already purchased"}
        end
      end
    )
  end
end
