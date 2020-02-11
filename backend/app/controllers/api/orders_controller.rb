module Api
  class OrdersController < ApplicationController

    # Create or find User
    #
    # @params [Object] order placement info
    # @return [Object] Order created Object
    def create
      # QUESTION: Lack of consistency on response contract for the API
      begin              
        service = OrderCreate.call(params: params)      
        if service.success?
          render json: service.result, status: :ok
        else
          render json: {error: service.error }, status: :bad_request
        end
      rescue ArgumentError => e
        render json: {message: 'Argument Error : ' + e.message}, status: :expectation_failed
      rescue StandardError => e
        render json: {message: 'Invalid Request : ' + e.message}, status: :bad_request
      end 
    end

  end
end
