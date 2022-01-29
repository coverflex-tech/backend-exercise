mix credo --strict
mix format --dry-run --check-formatted
mix sobelow --ignore Config.HTTPS
mix coveralls