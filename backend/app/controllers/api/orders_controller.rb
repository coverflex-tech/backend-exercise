class Api::OrdersController < Api::BaseController
  require 'json'

  before_action :set_user, only: [:create]

  def create
    # find the user based on the username
    # check user exists
    return user_not_found if @user.nil?

    products = @body["items"]
    total = 0
    # find the products in the database and throw an error if they dont exist
    products.each do |product|
      product_instance = find_product(product)
      return products_not_found if product_instance.nil?

      # check if the user already has the products and throw an error if they have
      return products_already_purchased if @user.products.include?(product_instance)

      # add the product price to the total order price
      total += product_instance.price
    end

    # calculate the order total and check if the user has sufficient balance
    return insufficient_balance if @user.balance < total

    # subtract the total from the users balance
    # create order and order products instances
    create_orders(products, total)

    # list product names in order for the json view
    @product_names = @order.products.map { |product| product.name }
  end

  private

  def subtract_order_price(total)
    total.round(2)
    @user.balance -= total
    @user.save
  end

  def create_orders(products, total)
    subtract_order_price(total)
    @order = Order.create(user: @user, total: total)
    products.each do |product|
      product_instance = find_product(product)
      OrderProduct.create(product: product_instance, order: @order)
    end
  end

  def find_product(product)
    Product.where(name: product.capitalize).first
  end

  # used for testing
  def show_data
    render json: { data: "#{@body["user_id"]}" }
  end

  def set_user
    request_body = JSON.parse(request.raw_post)
    @body = request_body["order"]
    @user = User.where(username: "#{@body["user_id"]}").first
    # authorize @user
  end

  def products_not_found
    render json: { error: "products_not_found" }, status: 400
  end

  def products_already_purchased
    render json: { error: "products_already_purchased" }, status: 400
  end

  def insufficient_balance
    render json: { error: "insufficient_balance" }, status: 400
  end

  def user_not_found
    render json: { error: "user_not_found" }, status: 400
  end
end
