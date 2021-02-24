defmodule Backend.Order do
  use Ecto.Schema
  import Ecto.Changeset
  alias Ecto.Multi
  alias Backend.User

  @primary_key {:order_id, :binary_id, autogenerate: true}

  @derive {Jason.Encoder, only: [:order_id, :data]}

  @type t :: %__MODULE__{}

  schema "orders" do
    embeds_one :data, Data, primary_key: false, on_replace: :update do
      @derive Jason.Encoder
      field :user_id
      field :items, {:array, :string}
      field :total, :integer
    end
  end

  def changeset(order, attrs) do
    order
    |> cast(attrs, [])
    |> cast_embed(:data, with: &data_changeset/2)
  end

  defp data_changeset(data, attrs) do
    cast(data, attrs, [:user_id, :items, :total])
  end

  @doc """
  Tries to create an order
  """
  @spec create(String.t(), [String.t()]) ::
          {:ok, t()}
          | {:error, :products_not_found | :products_already_purchased | :insufficient_balance}
  def create(user_id, items) do
    with {:ok, user} = Backend.User.get_or_create(user_id),
         :ok <- already_purchased_products(user.data.product_ids, items),
         products = Backend.Product.list(),
         {:ok, filtered_products} <- check_and_filter_products(products, items),
         {:ok, total, new_balance} <-
           calculate_total_and_balance(user.data.balance, filtered_products) do
      create_user_order(user, items, total, new_balance)
    else
      :already_purchased -> {:error, :products_already_purchased}
      :product_not_found -> {:error, :products_not_found}
      :insufficient_balance -> {:error, :insufficient_balance}
    end
  end

  defp already_purchased_products(user_products, items) do
    if Enum.any?(items, &Enum.member?(user_products, &1)) do
      :already_purchased
    else
      :ok
    end
  end

  defp check_and_filter_products(_products, []), do: :product_not_found

  defp check_and_filter_products(products, items) do
    filtered_products = Enum.filter(products, fn product -> product.id in items end)

    if length(filtered_products) == length(items) do
      {:ok, filtered_products}
    else
      :product_not_found
    end
  end

  defp calculate_total_and_balance(user_balance, products) do
    products
    |> Enum.reduce_while({user_balance, 0}, fn product, {balance, total} ->
      new_balance = balance - product.price

      if new_balance < 0 do
        {:halt, :insufficient_balance}
      else
        {:cont, {new_balance, total + product.price}}
      end
    end)
    |> case do
      {new_balance, total} -> {:ok, total, new_balance}
      :insufficient_balance -> :insufficient_balance
    end
  end

  defp create_user_order(user, items, total, new_balance) do
    order_params = %{user_id: user.user_id, items: items, total: total}
    user_params = %{balance: new_balance, product_ids: items ++ user.data.product_ids}

    Multi.new()
    |> Multi.insert(:order, __MODULE__.changeset(%__MODULE__{}, %{data: order_params}))
    |> Multi.update(:user, User.changeset(user, %{data: user_params}))
    |> Backend.Repo.transaction()
    |> case do
      {:ok, %{order: order}} -> {:ok, order}
      err -> err
    end
  end
end
