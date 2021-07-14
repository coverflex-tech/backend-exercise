class Api::UsersController < Api::BaseController
  before_action :set_user, only: [:show]

  def show
    unless @user
      @user = User.create(username: "#{params[:id]}", email: "#{params[:id]}@gmail.com", password: "123456")
    end
    @product_names = @user.products.map { |product| product.name.downcase }
  end

  private

  def set_user
    @user = User.where(username: "#{params[:id]}").first
    # authorize @user
  end
end
