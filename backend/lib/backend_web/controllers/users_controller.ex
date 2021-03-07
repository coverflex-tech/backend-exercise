defmodule BackendWeb.UsersController do
  use BackendWeb, :controller
  alias Backend.Users.{Order, User}

  @manager_module Application.compile_env!(:backend, [:modules, :user_manager])
  @product_manager_module Application.compile_env!(:backend, [:modules, :product_manager])

  def get(conn, %{"user_id" => user_id}) do
    with {:user_found, {:error, :invalid_user_id}} <- {:user_found, @manager_module.get(user_id)},
         {:user_created, {:error, reason}} <- {:user_created, @manager_module.add(user_id)} do
      out_json(conn, 500, inspect(reason))
    else
      {:user_found, {:ok, user}} -> out_json(conn, user)
      {:user_created, {:ok, user}} -> out_json(conn, 201, user)
    end
  end

  def order(conn, %{"order" => %{"items" => items, "user_id" => user_id}}) do
    items = Enum.sort(items)

    with {:ok, ^items, total} <- get_products_total(items),
         {:ok, order} <- @manager_module.order(user_id, items, total) do
      out_json(conn, order)
    else
      {:ok, _, _} -> out_json(conn, 400, %{error: :products_not_found})
      {:error, reason} -> out_json(conn, 400, %{error: reason})
    end
  end

  defp get_products_total(items) do
    {ids, total} =
      items
      |> @product_manager_module.get()
      |> Enum.reduce({[], 0}, fn %{id: id, price: price}, {ids, total} ->
        {[id | ids], total + price}
      end)

    {:ok, Enum.sort(ids), total}
  end

  defimpl Jason.Encoder, for: [User] do
    def encode(%{user_id: id, balance: balance, product_ids: product_ids}, opts) do
      Jason.Encode.map(
        %{
          user: %{
            user_id: id,
            data: %{
              balance: balance,
              product_ids: product_ids
            }
          }
        },
        opts
      )
    end
  end

  defimpl Jason.Encoder, for: [Order] do
    def encode(%{order_id: id, items: product_ids, total: total}, opts) do
      Jason.Encode.map(
        %{
          order: %{
            order_id: id,
            data: %{
              items: product_ids,
              total: total
            }
          }
        },
        opts
      )
    end
  end

  defp out_json(conn, status \\ 200, payload) do
    conn
    |> put_status(status)
    |> json(payload)
  end
end
