defmodule Backend.User do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:user_id, :string, autogenerate: false}

  schema "users" do
    embeds_one :data, Data, primary_key: false, on_replace: :update do
      field :balance, :integer, default: 1000
      field :product_ids, {:array, :string}, default: []
    end
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [])
    |> cast_embed(:data, with: &data_changeset/2)
  end

  defp data_changeset(data, attrs) do
    cast(data, attrs, [:balance, :product_ids])
  end
end
