# coverflex recruitment test 

The test application has been build with [rails api module](https://guides.rubyonrails.org/api_app.html) and tested locally. 

The object of this test is to build a  app that can be used by company employees to self-manage their benefits.

# Tech used on this implementation

  - ruby (2.6.5)
  - rails api module
  - psql
  - rpsec (test implemented modules)

# Tests Behaviour Driven Development for Ruby (rspec)

  - testing application with [rspec](https://github.com/rspec/rspec)

```sh
$ bundle install
$ RAILS_ENV=test bundle exec rake db:create db:migrate
$ bundle exec rspec 
```  

# Rails based test locally

**Terminal 1 - running react app:**
```sh
$ cd frontend
$ yarn install
$ yarn start
```  

**Terminal 2 - running rails api:**
```sh
$ cd backend
$ bundle exec rake db:create db:migrate db:seed
$ bundle exec rails s -p 4000
```  

## notes 
**seed on creation of tables**
- a small seed with 10 fake products has been created to populate the table products
- a default balance is added when the user is created

# rake tasks to add credit manually
**this should be runned after migrations**

```sh
$ cd backend
$ bundle exec rake credit:add 
```  

- choose an existing user, by username
- choose the amount 

# rake tasks to add products manually
**this should be runned after migrations**

```sh
$ cd backend
$ bundle exec rake credit:add 
```  

- choose product code
- choose product name
- choose product price

## build process:

  - set the model user and tests
  - set the model balance (optional) and tests
  - set the model order and tests
  - set the model product and tests
  - set the model purchased (product placed) and tests  
  - create a task add amount to balance and new products
  - generate routes necessary to provide valid responses 
  - generate controller to GET a specific user callng a service that normalize the input and create or find user by username and retrieve object
  - generate controller to GET all products, using a serializer to obtain the products from db
  - generate controller POST products and add it to new order validating if they exist, if not already purchased and if the user have a valid balance    
  
## based on thew approach, should be missing security: 

proposals not implemented:
- Securing API with Tokens & JWT OR Securing API with API Key & Secret
- add some cache layer to purchased products
- add some cache layer to users

