# Coverflex.Benefits

To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.setup`
  * Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## Setup PostgreSQL

    psql postgres
    postgres=# CREATE ROLE benefitsphoenix WITH LOGIN PASSWORD 'passWJKN64$';
    postgres=# ALTER ROLE benefitsphoenix CREATEDB;
    postgres=# exit

## Generated with

mix phx.new backend --app coverflex --module Coverflex.Benefits --database postgres --no-assets --no-html

## Learn more

  * Official website: https://www.phoenixframework.org/
  * Guides: https://hexdocs.pm/phoenix/overview.html
  * Docs: https://hexdocs.pm/phoenix
  * Forum: https://elixirforum.com/c/phoenix-forum
  * Source: https://github.com/phoenixframework/phoenix
  
