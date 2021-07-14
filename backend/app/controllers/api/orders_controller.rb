class Api::OrdersController < Api::BaseController
  require 'json'

  before_action :set_user, only: [:create]

  def create
    # find the user based on the username
    # check user exists
    return user_not_found if @user.nil?

    # find the products in the database and throw an error if they dont exist

    # check if the user already has the products and throw an error if they have

    # calculate the order total and check if the user has sufficient balance

    # subtract the total from the users balance

    # create order products
    # @order = Order.new ....
  end

  private

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
