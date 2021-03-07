# Test performance for products.

Code.require_file("bench/bench_util.ex")

alias Bench.Util
alias Backend.Users.Manager

Logger.configure(level: :info)

runs = Util.setup_runs([100, 1_000, 10_000, 100_000])

Benchee.run(
  runs,
  inputs: %{
    "Get one" => %{
      setup: fn count ->
        Util.clean_db()

        user_id =
          count
          |> Util.add_users()
          |> Enum.at(0)
          |> Map.get(:user_id)

        {&Manager.get/1, user_id}
      end
    }
  },
  after_scenario: fn _input -> Util.clean_db() end,
  warmup: 5,
  formatters: [
    {Benchee.Formatters.HTML,
     file: "bench/out/backend/users/manager_profile.html", auto_open: false},
    Benchee.Formatters.Console
  ],
  print: [fast_warning: false]
)
