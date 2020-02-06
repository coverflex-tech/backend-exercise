defmodule Backend.Benefits.Order do
  use Ecto.Schema
  import Ecto.Changeset
  alias Backend.Accounts.User

  schema "orders" do
    field :data, :map
    belongs_to :user, User

    timestamps()
  end

  @doc false
  def changeset(order, attrs) do
    order
    |> cast(attrs, [:data])
    |> validate_required(:data)
    |> validate_map_contains(:data, :items)
    |> validate_map_contains(:data, :total)
    |> validate_change(:data, &products_not_found/2)
    |> put_assoc(:user, attrs.user)
    |> validate_purchased(attrs.user)
    |> validate_balance(attrs.user)
  end

  defp products_not_found(field, value) do
    if Enum.any?(value[:items]), do: [], else: [title: "products_not_found"]
  end

  defp validate_map_contains(changeset, field, nested) do
    validate_change(changeset, field, fn
      current_field, value ->
        case Map.fetch(value, nested) do
          {:ok, v} when v != nil -> []
          _ -> [{current_field, "This field must have a #{nested}"}]
        end
    end)
  end

  defp validate_purchased(changeset, user) do
    validate_change(changeset, :data, fn
      current_field, data ->
        {:ok, list} = Map.fetch(data, :items)
        {:ok, user_list} = Map.fetch(user.data, "product_ids")

        if Enum.any?(list, fn item -> Enum.member?(user_list, item) end) do
          [title: "products_already_purchased"]
        else
          []
        end
    end)
  end

  defp validate_balance(changeset, user) do
    validate_change(changeset, :data, fn
      current_field, data ->
        {:ok, total} = Map.fetch(data, :total)
        {:ok, balance} = Map.fetch(user.data, "balance")

        if total > balance, do: [title: "insufficient_balance"], else: []
    end)
  end
end
