module Api
  class UsersController < ApplicationController  
  
    # Create or find User
    #
    # @params [String] user_id, username from user
    # @return [Object] The user selected
    def show
      begin              
        service = UserFindOrCreate.call(user_id: params[:id])      
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