# Index
1. [Getting Started](#getting-started)
2. [Documentation](#documentation)

# Getting Started

To set up the project locally, you will need to install [asdf](https://github.com/asdf-vm/asdf) and docker-compose, so before continuing, please make sure you have these two. 

## Installation
1. Clone the Repo
```
$ git clone https://github.com/coverflex-tech/backend-exercise
```
2. Change the directory:
```
$ cd backend-exercise
```
3. Install OTP and Elixir:
```
$ asdf install
```
4. Change the directory to ./benefits
```
$ cd benefits/
```
5. Fetch the dependencies
```
$ mix deps.get
```
6. Initiate the database using docker-compose
```
$ docker-compose up -d
```
7. Run the project's setup command
```
$ mix benefits.setup
$ mix benefits.test_setup
```

8. Start the Phoenix server
```
iex -S mix phx.server
```

# Documentation

## Get or Create User

Retrieves a user by its username, creating it if it does not exist yet

### Request
```http
GET /api/users/{{user_id}}
```
### Response

#### Status 200
```json
{
  "user": {
    "user_id": "username",
    "data": {
      "balance": 50.0,
      "product_ids": [1, 2]
    }
  }
}
```

## List Products

Returns all products available for purchasing

### Request
```http
GET /api/products
```
### Response

#### Status 200
```json
{
  "products": [
    {
      "id": 1,
      "name": "Netflix",
      "price": 30.5
    },
    {
      "id": 2,
      "name": "Apple Watch",
      "price": 540.3
    }
  ]
}
```

## Create Order

Creates a new order

```http
POST /api/orders
```

### Request Body
```json
{
  "order": {
    "user_id": "username",
    "items": [1, 4, 6]
  }
}
```

### Response

#### Status 201

When the order creation succeed
```json
{
  "order": {
    "data": {
      "items": [1],
      "total": 500.3
    },
    "order_id": 2
  }
}
```

#### Status 400

When the user doesn't have enough balance

```json
{
  "error": "insufficient_balance"
}
```

When one or more items are already purchased

```json
{
  "error": "products_already_purchased"
}
```

When one or more items are already purchased

```json
{
  "error": "products_already_purchased"
}
```

When a product is not found

```json
{
  "error": "products_not_found"
}
```