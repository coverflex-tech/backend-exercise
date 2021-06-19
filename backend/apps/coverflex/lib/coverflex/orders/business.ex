import Ecto.Query, warn: false

alias Coverflex.Products.Product
alias Coverflex.Accounts.{User, UserAccount}
alias Coverflex.Orders.{Order, OrderItem}
alias Ecto.Multi
alias Coverflex.Repo

defmodule Coverflex.Orders.Business do
  def validate_if_product_id_is_uuid(multi, products) do
    multi
    |> Multi.run(
      :invalid_product_ids,
      fn _repo, %{} ->
        invalid_product_ids =
          Enum.filter(products, fn product -> :error == Ecto.UUID.dump(product) end)

        case(length(invalid_product_ids)) do
          0 -> {:ok, true}
          _ -> {:error, invalid_product_ids}
        end
      end
    )
  end

  def validate_if_user_has_enough_balance_to_buy_products(multi, user_id, products) do
    multi
    |> Multi.run(
      :user,
      fn _repo, _ ->
        case Repo.get_by(User, user_id: user_id) |> Repo.preload([:account]) do
          nil -> {:error, {:not_found, user_id}}
          user -> {:ok, user}
        end
      end
    )
    |> Multi.run(
      :products,
      fn _repo, _ ->
        products_from_database = from(p in Product, where: p.id in ^products) |> Repo.all()

        case length(products_from_database) == length(products) do
          true ->
            {:ok, products_from_database}

          false ->
            products_from_database_id = for product <- products_from_database, do: product.id

            products_not_found =
              Enum.filter(products, fn product_id ->
                product_id not in products_from_database_id
              end)

            {:error, {:not_found, products_not_found}}
        end
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
      :sufficient_balance?,
      fn _repo, %{products_price: products_price, user: user} ->
        case user.account.balance >= products_price do
          true ->
            {:ok, true}

          false ->
            {:error, false}
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
    |> Ecto.Multi.merge(fn %{order: order, products: products} ->
      Enum.reduce(products, Multi.new(), fn product, multi ->
        multi
        |> Multi.insert(
          {:product, product.id},
          OrderItem.changeset(%OrderItem{}, %{
            price: product.price
          })
          |> Ecto.Changeset.put_assoc(:product, product)
          |> Ecto.Changeset.put_assoc(:order, order)
        )
      end)
    end)
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
      :products_already_purchased,
      fn _repo, %{products_previously_purchased: products_previously_purchased} ->
        case length(products_previously_purchased) do
          0 -> {:ok, false}
          _ -> {:error, products_previously_purchased}
        end
      end
    )
  end

  def update_user_account_balance(multi) do
    multi
    |> Multi.update(
      :updated_account,
      fn %{products_price: products_price, user: user} ->
        UserAccount.update_changeset(user.account, %{
          balance: user.account.balance - products_price
        })
      end
    )
  end
end
