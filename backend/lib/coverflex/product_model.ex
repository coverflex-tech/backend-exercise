defmodule Coverflex.Benefits.ProductModel do

  import Ecto.Query, only: [from: 2]

  alias Coverflex.Benefits.Repo
  alias Coverflex.Benefits.Product, as: DBProduct
  alias Coverflex.Benefits.User, as: DBUser
  alias Coverflex.Benefits.UserProduct
    
  defmodule Product do
    @enforce_keys [:id]
    defstruct [:id, :name, price: 0]
  end

  def create(id, name, price \\ 0) do
    {:ok, product} = Repo.insert %DBProduct{product_id: id, name: name, price: price}
    %Product{id: product.product_id, name: product.name, price: product.price}
  end

  def get_all() do
    Repo.all(DBProduct)
    |> Enum.map(&%Product{id: &1.product_id, name: &1.name, price: &1.price})
  end
  
  def get_by_user(user_id) do
    case Repo.get_by(DBUser, user_id: user_id) do
        nil -> []
        user -> from(user_prod in UserProduct,
                       where: user_prod.user_id == ^user.id,
                       join: prod in DBProduct,
                       on: user_prod.product_id == prod.id,
                       select: prod)
                |> Repo.all()
                |> Enum.map(&%Product{id: &1.product_id, name: &1.name, price: &1.price})
    end
  end
  
  def total(products) do
    Enum.reduce(products, 0, &(&1.price + &2))
  end

end
