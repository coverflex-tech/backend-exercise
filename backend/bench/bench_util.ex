defmodule Bench.Util do
  @moduledoc """
  Utility functions to keep the benchmark code simpler.
  """

  alias Backend.Repo
  alias Backend.Products.Product
  alias Backend.Users.{Order, User}

  def clean_db() do
    Repo.delete_all(Product)
    Repo.delete_all(User)
    Repo.delete_all(Order)
  end

  def add_products(count, offset \\ 0) when is_integer(count) do
    add_record(
      Product,
      fn idx ->
        id = "product_#{idx}"
        %{id: id, name: id, price: idx}
      end,
      count,
      offset
    )
  end

  def add_users(count, offset \\ 0) when is_integer(count) do
    add_record(
      User,
      fn idx ->
        id = "user_#{idx}"
        %{user_id: id, balance: idx, product_ids: []}
      end,
      count,
      offset
    )
  end

  def add_record(schema, create_fun, count, offset \\ 0) when is_integer(count) do
    date =
      NaiveDateTime.utc_now()
      |> NaiveDateTime.truncate(:second)

    records =
      Enum.reduce(offset..count, [], fn idx, acc ->
        record =
          idx
          |> create_fun.()
          |> Map.put(:inserted_at, date)
          |> Map.put(:updated_at, date)

        [record | acc]
      end)

    # Insert 10_000 at a time
    records
    |> Enum.chunk_every(10_000)
    |> Enum.each(&Repo.insert_all(schema, &1))

    records
  end

  def setup_runs(counts) do
    Enum.into(counts, %{}, fn count ->
      {
        "#{count}",
        {
          fn
            {fun, args} when is_function(fun) -> fun.(args)
            fun when is_function(fun) -> fun.()
            _ -> raise "Not a function"
          end,
          before_scenario: fn %{setup: before_scenario} ->
            before_scenario.(count)
          end
        }
      }
    end)
  end
end
