defmodule Backend.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias __MODULE__, as: User

  @primary_key {:user_id, :string, autogenerate: false}

  @derive {Jason.Encoder, only: [:user_id, :data]}

  @type t :: %User{}

  schema "users" do
    embeds_one :data, Data, primary_key: false, on_replace: :update do
      @derive Jason.Encoder
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

  @doc """
  Returns an existing user or creates a user with the given user_id
  """
  @spec get_or_create(String.t()) :: {:ok, t()}
  def get_or_create(user_id) do
    case Backend.Repo.get(User, user_id) do
      nil ->
        Backend.Repo.insert(%User{user_id: user_id, data: %User.Data{}})

      user ->
        {:ok, user}
    end
  end
end
