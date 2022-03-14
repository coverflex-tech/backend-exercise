defmodule Benefits.User do
  @moduledoc false

  use Ecto.Schema

  import Ecto.Changeset
  import Ecto.Query

  alias Benefits.{Order, OrderProducts, Repo, Wallet}

  @primary_key {:id, :binary_id, autogenerate: true}

  schema "users" do
    field(:username, :string)
    field(:bought_products_ids, {:array, :string}, virtual: true)

    has_one(:wallet, Wallet)

    timestamps()
  end

  @doc false
  def changeset(user \\ %__MODULE__{}, attrs) do
    user
    |> cast(attrs, [:username])
    |> validate_required([:username])
    |> unique_constraint(:username)
  end

  def load_bought_product_ids(%__MODULE__{id: user_id} = user) do
    ids =
      user_id
      |> bought_product_ids_query
      |> Repo.all()

    Map.put(user, :bought_products_ids, ids)
  end

  defp bought_product_ids_query(user_id) do
    Order
    |> where([o], o.user_id == ^user_id)
    |> join(:inner, [o], po in OrderProducts, on: o.id == po.order_id)
    |> select([o, po], po.product_id)
  end
end
