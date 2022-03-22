defmodule Backend.Orders.Create do
  alias Backend.Products
  alias Backend.Users
  alias Backend.Users.Schemas.User
  alias Backend.Orders.Schemas.{Order, OrderItem}

  alias Ecto.Multi

  def call(%{user_id: user_id, order_items: items_ids}) do
    order_items =
      items_ids
      |> prepare_items()
      |> load_items_products()

    order = %Order{
      user_id: user_id,
      order_items: order_items,
      total: sum_total(order_items)
    }

    if all_items_exists?(order) do
      Multi.new()
      |> Multi.run(:load_user, fn repo, _changes ->
        load_user(repo, user_id)
      end)
      |> Multi.run(:all_items_are_new, fn _repo, changes ->
        user = Map.get(changes, :load_user)
        check_all_items_are_new(order, user)
      end)
      |> Multi.run(:user_has_enough_balance, fn _repo, changes ->
        user = Map.get(changes, :load_user)
        check_user_has_enough_balance(user, order)
      end)
      |> Multi.run(:create_order, fn repo, changes ->
        order = Map.get(changes, :user_has_enough_balance)
        create_order(repo, order)
      end)
      |> Multi.run(:update_user_balance, fn repo, changes ->
        user = Map.get(changes, :load_user)
        order = Map.get(changes, :create_order)
        update_user_balance(repo, user, order)
      end)
      |> run_transaction()
    else
      {:error, :products_not_found}
    end
  end

  defp update_user_balance(repo, %User{} = user, %Order{} = order) do
    new_balance = Decimal.sub(user.balance, order.total)

    Users.Update.call(repo, user, %{balance: new_balance})
  end

  defp create_order(repo, %Order{} = order) do
    items_map = Enum.map(order.order_items, fn item -> %{product_id: item.product_id} end)

    %Order{}
    |> Order.changeset(%{user_id: order.user_id, total: order.total})
    |> Ecto.Changeset.put_assoc(:order_items, items_map)
    |> repo.insert()
  end

  defp run_transaction(multi) do
    case Backend.Repo.transaction(multi) do
      {:error, _operation, reason, _changes} ->
        {:error, reason}

      {:ok, %{create_order: order}} ->
        {:ok, order}
    end
  end

  defp load_user(repo, user_id) do
    case Users.Get.call(repo, user_id) do
      %User{} = user -> {:ok, user}
      :not_found -> {:error, :user_not_found}
    end
  end

  defp prepare_items(order_items) do
    Enum.map(order_items, fn item ->
      %OrderItem{product_id: item}
    end)
  end

  defp load_items_products(order_items) do
    Enum.map(order_items, fn item ->
      product = Products.Get.call(%{id: item.product_id})
      %{item | product: product}
    end)
  end

  defp all_items_exists?(%Order{} = order) do
    Enum.all?(order.order_items, fn item -> nil != item.product end)
  end

  defp sum_total(order_items) do
    Enum.reduce(order_items, Decimal.new("0.00"), fn item, total ->
      Decimal.add(total, item.product.price)
    end)
  end

  defp check_user_has_enough_balance(%User{balance: balance}, %Order{total: total} = order) do
    has_found? = :gt != Decimal.compare(total, balance)

    if has_found? do
      {:ok, order}
    else
      {:error, :insufficient_balance}
    end
  end

  defp check_all_items_are_new(%Order{order_items: order_items} = order, %User{
         order_items: user_items
       }) do
    order_items_id = Enum.map(order_items, & &1.product_id)

    all_new? = Enum.any?(user_items, fn item -> Enum.member?(order_items_id, item.product_id) end)

    if all_new? != true do
      {:ok, order}
    else
      {:error, :products_already_purchased}
    end
  end
end
