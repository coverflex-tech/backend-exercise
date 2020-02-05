defmodule Backend.Benefits.Order do
  use Ecto.Schema
  import Ecto.Changeset

  schema "orders" do
    field :data, :map
    field :user_id, :id

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
  end

  defp products_not_found(field, value) do
    if Enum.any?(value[:items]) do
      []
    else
      [title: "products_not_found"]
    end
  end

  defp validate_map_contains(changeset, field, nested) do
    validate_change(changeset, field, fn
      current_field, value ->
        case Map.fetch(value, nested) do
          {:ok, v} when v != nil -> []
          :error -> [{current_field, "This field must have a #{nested}"}]
          _ -> [{current_field, "This field must have a #{nested}"}]
        end
    end)
  end
end
