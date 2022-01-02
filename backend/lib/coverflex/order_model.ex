defmodule Coverflex.Benefits.OrderModel do

  import Ecto.Query, only: [from: 2]
  import Ecto.Changeset, only: [change: 2]

  alias Coverflex.Benefits.Repo
  alias Coverflex.Benefits.Product, as: DBProduct
  alias Coverflex.Benefits.User, as: DBUser
  alias Coverflex.Benefits.Vallet
  alias Coverflex.Benefits.Order, as: DBOrder
  alias Coverflex.Benefits.UserProduct
  alias Coverflex.Benefits.OrderProduct
  alias Coverflex.Benefits.ProductModel
    
  defmodule Order do
    @enforce_keys [:id]
    defstruct [:id, :user_id, items: [], total: 0]
  end

  def create(user_id, items) do
    if already_has_product?(user_id, items) do
      {:error, :products_already_purchased}
    else
      user = Repo.get_by(DBUser, user_id: user_id)
      vallet = Repo.get_by(Vallet, user_id: user.id)
      products = products_by_ids(items)
      cond do
        Enum.count(products) != Enum.count(items) -> 
          {:error, :products_not_found}
        Enum.reduce(products, 0, &(&1.price + &2)) > vallet.balance ->
          {:error, :insufficient_balance}
        true ->
          {:ok, order} = place_order(user, products, vallet)
          :ok = add_products(user, products)
          {:ok, order}
      end
    end
  end
  
  defp already_has_product?(user_id, items) do
    products_on_user = ProductModel.get_by_user(user_id)
                       |> Enum.map(&(&1.id))
                       |> MapSet.new()
    Enum.any?(items, &(MapSet.member?(products_on_user, &1)))
  end
  
  defp products_by_ids(ids) do
    Repo.all from(p in DBProduct, where: p.product_id in ^ids)
  end
  
  defp place_order(user, products, vallet) do
    total = Enum.reduce(products, 0, &(&1.price + &2))
    {:ok, order} = Repo.insert %DBOrder{user_id: user.id, total: total}
    Enum.each(products, fn product ->
      Repo.insert! %OrderProduct{order_id: order.id,
                                 product_id: product.id}
    end)
    Repo.update! change vallet, balance: vallet.balance - total
    {:ok, %Order{id: Integer.to_string(order.id), 
                 user_id: user.user_id, 
                 items: Enum.map(products, &(&1.product_id)),
                 total: total}}
  end
  
  defp add_products(user, products) do
    Enum.each(products, fn product ->
      Repo.insert! %UserProduct{user_id: user.id, product_id: product.id}
    end)
  end

end
