# Test performance for products.

Code.require_file("bench/bench_util.ex")

alias Bench.Util
alias Backend.Products.Manager

Logger.configure(level: :info)

runs = Util.setup_runs([100, 1_000, 10_000, 100_000])

Benchee.run(
  runs,
  inputs: %{
    "Get all" => %{
      setup: fn count ->
        Util.clean_db()
        Util.add_products(count)

        &Manager.get/0
      end
    },
    "Get one" => %{
      setup: fn count ->
        Util.clean_db()

        product_id =
          count
          |> Util.add_products()
          |> Enum.at(0)
          |> Map.get(:id)

        {&Manager.get/1, product_id}
      end
    },
    "Get half" => %{
      setup: fn count ->
        Util.clean_db()

        half = Kernel.div(count, 2)

        product_ids =
          count
          |> Util.add_products()
          |> Enum.take(half)
          |> Enum.map(& &1.id)

        {&Manager.get/1, product_ids}
      end
    }
  },
  after_scenario: fn _input -> Util.clean_db() end,
  warmup: 5,
  formatters: [
    {Benchee.Formatters.HTML,
     file: "bench/out/backend/products/manager_profile.html", auto_open: false},
    Benchee.Formatters.Console
  ],
  print: [fast_warning: false]
)
