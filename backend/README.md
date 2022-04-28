# Products - Backend

To start the Phoenix server:

  * Install dependencies with `mix deps.get`
  * Create and migrate the database with `mix ecto.setup`
  * Seed the database with `mix run priv/repo/seeds.exs`
  * Start the Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser, or use this address as the base URL for the frontend to call.

## 1 - Initialize Phoenix app

This first commit only creates the Phoenix app. It was created with the following command:

`mix phx.new backend --no-assets --no-html --no-gettext --no-dashboard --no-live --no-mailer`

That way I simply don't get stuff like `.heex` templates, which I do not need.

It runs and opens an error page when visiting the URL above, because no routes are properly filled out yet.

## 2 - Create Benefits context

This context will hold our Users, Products and Orders. For now we are focusing only on sending a response to requests made to `/api/users/:user_id`, even if it is a stub.

This requires running the following command:

`mix phx.gen.json Benefits User users user_id:string:unique balance:integer`

We then make several adjustments, like deleting code we likely won't use. (We can always bring it back later!) We also install the CORS Plug to allow cross-origin resource sharing to the frontend.

## 3 - Create records in the database

Our API spec says that, if provided with a non-existent `user_id`, we should create one. This suggests we should start using our database and make the `show` function in the UserController a bit smarter.

For convenience, we will get rid of the default-generated `id` column and have `user_id` be the primary key for our table.

Notice: the migration was changed before any entries had been inserted. No databases were hurt in the making of this project.

## 4 - Implement /products endpoint

We want to return all the products, with an `id`, `name` and `price`, as the response to a `GET /api/products` request. We'll assume the set of products is fixed and will be seeded into the database, since there are no endpoints for creating/updating this resource.

## 5 - Migrate orders and benefits

A user can buy many products, and one product can be bought by many users. This suggests a many-to-many relationship, so that is what we'll implement next, starting with the data layer.

The POST request for an order can contain many products for a given user in the same order. Furthermore, a user can only buy a given product once. Therefore, we are going to have two new tables. One is `orders`, which simply records the User who made that purchase. Another is `benefits`, with three foreign keys, to a User, a Product and an Order. The combination of User and Product must be unique. These two tables will allow us to fulfill the remaining requirements for the API: list all of a User's products, and return the items included in an order (or an error if the user already has a given benefit).

This commit focuses on the migrations, the next one(s) will focus on the schemas and finally we'll implement the corresponding endpoint with its several possible responses.

## 6 - Create order and benefit schemas

We now need to set up the associations between all our tables at the schema level. This time, instead of generating the whole JSON package all at once, we'll start by perfecting the schema and then building upper layers. We need to make clear that a User has many Orders, an Order has many Benefits and there is a many-to-many relationship between Products and Users through Benefits. With this association, we can include a user's Products in the corresponding view; once we are actually creating the Benefits with the respective Order, this should automatically make the Users endpoint work correctly.

## 7 - Send basic response to orders endpoint

In this commit, we begin to send appropriate responses from all three endpoints. Products is fine, but we need to allow the API consumer to place an order, and we also need to include a user's benefits in the response. At first we will focus on the orders endpoint, sending a dummy response without the items or the correct total as we are not yet saving all the associations. It is worth noting that the POST request to Orders causes the creation of an entry in the database; as such, we send the default Phoenix HTTP response status of 201 Created, instead of 200 OK, to better match the standard semantics of HTTP statuses.

## 8 - Save order total

We need to calculate the total for the order and save it. We will assume for now that the product IDs sent in the POST request exist, that the requesting user does not yet have them and that they can afford these products.

## 9 - Save benefits for an order

Given the assumptions above, we'll create the Benefits corresponding to the order and include their IDs in the response to the POST request. This also allows us to send the products a user already owns in the response to the Users endpoint.

## 10 - Deduct price from user balance

Up until now we are not decreasing the user's balance by the amount necessary, so let's fix that. Let's also fix some tests.

## 11 - Fix errors: product absent or already bought

Due to DB-level constraints, we currently get Postgrex errors when trying to buy a non-existent product, or one that the user has already bought. We need to convert these errors into useful JSON messages for the frontend.

In order to be more specific, the error code 422 Unprocessable Entity is used instead of the more general 400 Bad Request. 404 Not Found could be used for the case where the order contains a non-existent product, but its semantics do not seem to fit well with a POST request that aims to create an order rather than find a given product. So 422 it is then.

## 12 - Test the API

Let's write and end-to-end test to make sure our API matches the spec. We'll also add some documentation and comments for clarity, delete an unused function, cleanup tasks like that.

## 13 - Perform a final cleanup

There were a few things that I'd thought of doing in this final commit.

We currently use `rescue` to deal with invalid products in orders, as they raise Postgrex errors. This is a deliberate choice over the option of inserting each product individually using a changeset; we use `Multi.insert_all`, which cannot use a changeset but batch-inserts the products, and this is a more efficient DB write operation. So we are not altering the code to use changesets there.

Another consideration was to format the response body in error messages to conform literally to the API spec. However, the frontend code does not rely on a specific format (or a specific HTTP error code, for that matter), so I've decided to just use the default Ecto format for the response.

Therefore, all that is left is to clarify a few parts of the code with docs and comments.
