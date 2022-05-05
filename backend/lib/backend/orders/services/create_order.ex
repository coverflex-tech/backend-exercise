defmodule Backend.Orders.Services.CreateOrder do
  alias Backend.Orders.Repository.Create
  alias Backend.Products.Repository.Get, as: GetProduct
  alias Backend.Products.Repository.Update, as: UpdateProduct
  alias Backend.Users.Repository.Get, as: GetUser
  alias Backend.Users.Repository.Update, as: UpdateUser

  @spec call(%{order: %{items: list(), user_id: String.t()}}) ::
          {:ok, map} | {:error, String.t()}
  def call(%{"order" => %{"user_id" => username, "items" => products_ids} = params}) do
    with {:ok, products} <- get_all_products(products_ids, []),
         {:ok, user} <- GetUser.call(username),
         amount <- calculate_amount(products),
         true <- user_has_enough_balance(user, amount) do
      response =
        params
        |> Map.merge(%{"total_amount" => amount})
        |> Create.call()

      case response do
        {:ok, %{id: order_id} = order} ->
          update_products(products_ids, order_id)

          UpdateUser.call(username, %{balance: Decimal.sub(user.balance, amount)})

          {:ok, Map.merge(order, %{items: products_ids})}

        error ->
          error
      end
    else
      error -> error
    end
  end

  defp get_all_products([], []), do: {:error, "products_not_found"}

  defp get_all_products([], products), do: {:ok, products}

  defp get_all_products([head | tail], products) do
    case GetProduct.call(head) do
      {:error, "Product not found"} -> get_all_products([], [])
      %{order_id: nil} = product -> get_all_products(tail, products ++ [product])
      %{order_id: _order_id} = _product -> get_all_products(:already_purchased)
    end
  end

  defp get_all_products(:already_purchased), do: {:error, "products_already_purchased"}

  defp user_has_enough_balance(%{balance: balance}, order_amount) do
    balance
    |> Decimal.sub(to_string(order_amount))
    |> Decimal.negative?()
    |> Kernel.not()
    |> case do
      true -> true
      false -> {:error, "insufficient_balance"}
    end
  end

  defp calculate_amount(products) do
    Enum.reduce(products, Decimal.new(0), fn %{price: price}, acc ->
      Decimal.add(price, Decimal.new(acc))
    end)
  end

  defp update_products(products_ids, order_id) do
    Enum.each(products_ids, fn id -> UpdateProduct.call(id, %{order_id: order_id}) end)
  end
end
