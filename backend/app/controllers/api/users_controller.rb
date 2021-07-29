class Api::UsersController < Api::BaseController
  before_action :set_user, only: [:show]

  def show
    @user ||= create_user(params[:id])
    @product_names = @user.products.map { |product| product.name.downcase }
  end

  private

  def create_user(username)
    User.create(username: username.to_s, email: "#{username}@gmail.com", password: "123456")
  end

  def set_user
    @user = User.where(username: params[:id].to_s).first
  end
end
