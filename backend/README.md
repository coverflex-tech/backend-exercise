# Backend

To start postgres:

  * Run on background with `docker-compose up -d postgres`

To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.setup`
  * Start Phoenix endpoint with `mix phx.server`

You can see all routes available with `mix phx.routes`

## Elixir & Postgres

I used Elixir with Phoenix because they implement a good separation of contexts and have the same dev flow compared with Ruby.
Postgres because is the default of Phoenix and is really useful to store maps.

## Decisions

As describe on main README an order receive an `user_id` but I'm not saving this on model instead I'm using a simple id generated on database.
I update the user product list when order is created but this solution can be handled async with a pubsub solution. I decide to use the most simple way to avoid over engineering on this test.

## To run tests

    cd backend
    mix test

## Problems found

There is no description for how to handle balance update. I decide to just update the current balance with selected products but there is an error when you remove and add another product.

The frontend don't send all products when you already have a product select. I decide to override all with the new given list.
