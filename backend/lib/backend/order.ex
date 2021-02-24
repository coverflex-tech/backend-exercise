defmodule Backend.Order do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:order_id, :binary_id, autogenerate: true}

  schema "orders" do
    embeds_one :data, Data, primary_key: false, on_replace: :update do
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
end
