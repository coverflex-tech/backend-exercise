# Benefits

## About

This challenge took me between 6-8h working in
my spare time from work.

I used the frontend application as a TDD reference,
so I started first by making the user "login"/creation flow
work, then I moved to the product list, then to placing
an order, &c.

My main concerns when designing the backend where:
  - separation of responsabilities between the web and the domain
  - separation between queries that read resources and commands
    that create/modify resources
  - atomic creation of new product orders
  - concurrency pitfalls when manipulating resources (specifically an user's balance)

Instead of using a relational data model between products-users-orders with
a n-to-n relation and join tables, I opted for using json binaries as supported by Postgresql >= 9.4.
This made things considerably simpler, but less flexible, as, e.g., new columns inside
the `products` table won't necessarily be reflected in embeds.

I used integers as "money" resources because floats would be a nightmare and Decimals or
external libraries (like `Money`) would be overkill.

I did not use background workers, but the order creation flow is a strong contender for that.

For testing, I used only standard unit tests. I did not use mocks or stubs but
did use factories for streamlining the creation of fixtures. I did not test the
views because they are only json anyway and asserting on the return of the
controllers should be enough.

## Running locally

To start the Phoenix server:

  * Run `docker-compose up -d` to start an instance of Postgres in the background
  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.setup`
  * Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

That should get it up and running on `localhost:4000` ready to receive calls from
the frontend application. Hopefully.

