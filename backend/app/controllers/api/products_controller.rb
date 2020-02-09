module Api
  class ProductsController < ApplicationController

    # List all products
    #
    # @params [null] 
    # @return [Object] All products available
    def index            
      render json: Product.all, root: 'products'
    end

  end
end