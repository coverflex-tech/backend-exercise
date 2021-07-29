class Api::OrdersController < Api::BaseController
  require 'json'

  before_action :set_data, only: [:create]
  before_action :set_user, only: [:create]
  before_action :set_products, only: [:create]

  def create
    # check products exist and check if already purchased then calculate total
    validate_products(@products)
    @total = calculate_order_total(@products)

    # check if the user has insufficient balance and throw an error if true
    return insufficient_balance unless @user.afford?(@total)

    # create the order
    @order = PlaceOrder.call(user: @user, products: @products, total: @total)
    @product_names = @order.products.map(&:name)
  end

  private

  def validate_products(products)
    return products_not_found unless @products.map(&:name).sort == @product_names.sort
    return products_already_purchased if (@user.products & products).any?
  end

  def calculate_order_total(products)
    products.map(&:price).sum
  end

  def set_data
    # request_body = JSON.parse(request.raw_post)
    @body = params["order"]
  end

  def set_user
    @user = User.where(username: @body['user_id'].to_s).first
    return user_not_found if @user.nil?
  end

  # fetch products from the database using 1 query
  def set_products
    @product_names = @body["items"].map(&:capitalize)
    @products = Product.where(name: @product_names)
  end

  def products_not_found
    return render json: { error: "products_not_found" }, status: 400
  end

  def products_already_purchased
    return render json: { error: "products_already_purchased" }, status: 400
  end

  def insufficient_balance
    return render json: { error: "insufficient_balance" }, status: 400
  end

  def user_not_found
    return render json: { error: "user_not_found" }, status: 400
  end
end
