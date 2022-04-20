# Products - Backend

To start the Phoenix server:

  * Install dependencies with `mix deps.get`
  * Create and migrate the database with `mix ecto.setup`
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
