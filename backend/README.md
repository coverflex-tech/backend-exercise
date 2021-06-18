# Coverflex challenge

As we can see on the HLD bellow shows this project is an umbrella application with two applications.

![](./diagram/layers.png)

* coverflex - Here is where the business logic and database related operations lives
  
* coverflex_web - Here is just the rest API that interact with the `coverflex` layer 

## Business logic

The most complex business logic can be found in the function [Coverflex.Orders.buy_products](./apps/coverflex/lib/coverflex/orders.ex),
this is just an orchestration function that call other functions where each one do **only one thing**, we use the
[ecto Multi](https://hexdocs.pm/ecto/Ecto.Multi.html) to create the logic chain and put everything inside a database
transaction.

## Redirects

To avoid the user to see a not found page when try to access the index(/) we redirect the request to the
`Routes.product_path(conn, :index)` path.
