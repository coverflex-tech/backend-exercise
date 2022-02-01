# Benefits API - Backend

Backend API for a Benefits system that can be used by company employees to self-manage their benefits.

# Usage

For this backend to work properly, you need an up-and-running postgres database that by default is available on port `5432`. If you have such a database but it is running somewhere else follow the instructions below:

  1. Start by creating your own `.env` file and fill the credentials that you can see in the `.env.sample` file. 
  1. You shoud uncomment and fill the variables that you will need. Then just need to run `source .env`.

## Development environment

To start your Phoenix server in a dev environment:

  * Install dependencies, create and migrate your database with `mix setup`
  * Start Phoenix endpoint with `mix phx.server`

Now you can make calls to the benefits API using the [`http://localhost:4000`](http://localhost:4000) as the base URL.

## Test environment

To run the app's tests:

  * Install dependencies, create and migrate your database with `mix setup`
  * Run the tests with `mix test`
  * See the test coverage with `mix coveralls`

# Documentation

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc), by running `mix docs`, and accessed under the `doc/` folder.
Open the `index.html` and see the documentation in a browser.

To see all options available when generating docs, run `mix help docs`.
