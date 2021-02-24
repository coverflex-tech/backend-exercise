defmodule Backend.Product do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :string, autogenerate: false}

  @derive {Jason.Encoder, only: [:id, :name, :price]}

  @type t :: %__MODULE__{}

  schema "products" do
    field :name, :string
    field :price, :integer
  end

  @doc false
  def changeset(product, attrs) do
    product
    |> cast(attrs, [:id, :name, :price])
    |> validate_required([:id, :name, :price])
  end

  @doc """
  Returns the existing products in the database
  """
  @spec list() :: [t()]
  def list do
    Backend.Repo.all(__MODULE__)
  end
end
