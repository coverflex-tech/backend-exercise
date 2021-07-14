class Api::ProductsController < Api::BaseController
  def index
    @products = Product.all
  end
end
