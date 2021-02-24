# Coverflex Backend Challenge

## Setup

To run the backend you need to have Elixir 1.7+ and Erlang OTP 22+ installed.
Also you need to have a PostgreSQL database running locally on port 5432, you can start one by using the provided docker-compose service with the command `docker-compose up -d db`.

## Run application

To start the application you need to follow this steps:

- Fetch the application dependencies with `mix deps.get`
- Compile the application with `mix compile`
- Create database, execute migrations and seed the database with `mix ecto.setup`
- Start the application with `mix phx.server`

The application will be listening on port 4000 in your machine and expose a RESTful API at the path `/api`.

## Run tests

To run the application tests just run the command `mix test`. It should execute 20 tests.
