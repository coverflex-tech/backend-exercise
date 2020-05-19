# Coverflex Backend Exercise

This is a solution for the Coverflex backend exercise implemented with Elixir.

## Summary
This exercise requires the building of a backend that listens on some RESTful(-ish) endpoints for three resources. It should return JSON payloads.

**Users** can be read by string IDs. This GET request is **not** idempotent, since it creates a user if it does not exist already.

**Products** represent the benefits that a user can _order_. They have a price, and a human-friendly name.

**Orders** can be created with a POST request. They are linked to users, and encompass one or more products, the price total of which is stored by orders.
Users cannot order products they already have purchased, invalidating the whole order.
Users cannot order products if the order total is superior to their current balance.

## Backend Stack
* Erlang/OTP 22
* Elixir 1.10.3
* Phoenix 1.5.1
* PostgreSQL 12.3-alpine (🐋)
* Docker

## Installation
### Frontend
Navigate to the `/frontend` directory and install dependencies. Afterwards, prop up the dev server.
```bash
$ cd frontend
$ npm install

# [...]

$ npm start
```

### Backend
Follow the following instructions to install Elixir and Phoenix, the web framework for Elixir, as well as Docker.
* [Elixir](https://elixir-lang.org/install.html)
* [Phoenix](https://hexdocs.pm/phoenix/installation.html#content)
* [Docker](https://docs.docker.com/get-docker/)

Start a new terminal session and navigate to the root of the project.
```bash
cd backend-exercise
```

Spin up the PostgreSQL service in the background.
```bash
docker-compose up -d
```

Navigate to the `/backend` directory and install project dependencies.
```bash
cd backend
mix deps
```

Create a `Repo`, migrate the migrations and seed some starting `Products`. The postgres service needs to be up.
```bash
mix ecto.create
mix ecto.migrate
```

Go to `localhost:3000` and spend your FlexPoints!