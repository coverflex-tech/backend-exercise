## Up and Running

1. ```docker-compose build``` to build container images
1. ```docker-compose up -d``` to run projects
1. ```docker-compose exec backend mix ecto.seed``` to create initital product seeds (Netflix, Spotify and Amazon Prime)
1. ```docker-compose exec -e MIX_ENV=test backend mix test``` to run tests
1. ```docker-compose exec -e MIX_ENV=test backend mix test.watch``` to run tests on changes
1. ```docker-compose exec -e MIX_ENV=test backend mix credo``` to run credo analisys

# Coverflex Backend Exercise

Hello dear Backend developer!

Your Project Manager needs you to quickly build an app that can be used by company employees to self-manage their benefits.
Our Frontend Developer has already built a UI prototype to cover the required flows. You'll need to build an API to provide backend functionality to this prototype and integrate both.

The API should include these use cases:
* Retrieve data from a single user
    * users are indexed and queried by username
* Retrieve a collection of products
    * products must have a unique identifier, a price and a name
* Placing an order
    * users aren't allowed to place an order if their current balance isn't enough for the order total
    * users aren't allowed to order a product previously ordered
    * orders must record which user is ordering, which products are being ordered and what the total amount is

Our Frontend Developer is expecting these API endpoints:
- `GET /api/users/:user_id`
    - returns a single user
    - if user_id doesn't exist, it creates a new user
    - output `{"user": {"user_id": "johndoe", "data": {"balance": 500, "product_ids": [...]}}}`
- `GET /api/products`
    - returns a list of all products
    - output `{"products": [{id: "netflix", "name": "Netflix", price: 75.99}, ...] }`
- `POST /api/orders`
    - creates a new order
    - input `{"order": {"items": ["product-1", "product-2"], "user_id": "johndoe"}}`
    - output 200 `{"order": {"order_id": "123", "data": {"items": [...], "total": 500}}}`
    - output 400 `{"error": "products_not_found"}`
    - output 400 `{"error": "products_already_purchased"}`
    - output 400 `{"error": "insufficient_balance"}`

**Notes:**
- You're free to use whatever means and technology to achieve the goal


## Web App
Our Frontend Developer has kindly provided you a simple React app for you to test out your service.

Let me guide you through how to set it up:

1. Go ahead and clone this repo.
1. Go inside frontend folder : ```cd frontend/```
1. Make sure you have Node installed.
1. Install npm dependencies: ```npm install```
1. Run it in development mode: ```npm start```

Now you should see something at ```http://localhost:3000```

**Additional Requirements:**

In development mode, this react app is expecting the local backend service to expose port ```4000```.

## Setup

For this challenge, please fork this repository, and create your solution inside of it, located inside `backend` folder.
As soon as you are finished, go ahead and make a Pull Request back to this repository.

Good Luck! 🙌
