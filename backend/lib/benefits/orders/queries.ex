defmodule Benefits.Orders.Queries do
  @moduledoc """
  Queries the order schema.
  """
  alias Benefits.Repo
  alias Benefits.Users.User
  alias Benefits.Products.Product
  alias Benefits.Orders.Order

  import Ecto.Query

  @spec check_purchased(User.t(), [Product.t()]) ::
          :ok | {:error, :products_already_purchased}
  def check_purchased(%{username: username}, products) do
    to_purchase = products |> Enum.map(& &1.id) |> MapSet.new()

    not_purchased? =
      Order
      |> where([o], o.user_id == ^username)
      |> select([o], o.products)
      |> Repo.all()
      |> Enum.map(& &1.id)
      |> MapSet.new()
      |> MapSet.disjoint?(to_purchase)

    if not_purchased?, do: :ok, else: {:error, :products_already_purchased}
  end
end
