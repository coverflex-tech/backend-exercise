defmodule Benefits.Orders.Queries do
  @moduledoc """
  Queries the order schema.
  """
  import Ecto.Query

  alias Benefits.Orders.Order
  alias Benefits.Products.Product
  alias Benefits.Repo
  alias Benefits.Users.User

  @spec check_purchased(User.t(), [Product.t()]) ::
          :ok | {:error, :products_already_purchased}
  def check_purchased(%User{username: username}, products) do
    to_purchase = products |> Enum.map(& &1.id) |> MapSet.new()

    not_purchased? =
      Order
      |> where([o], o.user_id == ^username)
      |> select([o], o.products)
      |> Repo.all()
      |> List.flatten()
      |> Enum.map(& &1.id)
      |> MapSet.new()
      |> MapSet.disjoint?(to_purchase)

    if not_purchased?, do: :ok, else: {:error, :products_already_purchased}
  end
end
