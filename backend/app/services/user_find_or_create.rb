class UserFindOrCreate < BusinessProcess::Base

    # Specify requirements    
    needs :user_id    
  
    steps :init,
          :validate_params,
          :normalize_params,          
          :find_or_create_user,
          :user_products,
          :return    

    def init
      @username = user_id      
    end
  
    def validate_params      
      fail(:invalid_params_no_user_input) if @username.nil? || @username.blank?
    end

    def normalize_params               
      @username = ActiveSupport::Inflector.transliterate(@username.downcase.sub(/\s+/, '').to_s)
    end
    
    def find_or_create_user                  
      ActiveRecord::Base.transaction do
        @user = User.find_or_create_by(username: @username)      
      end
    rescue ActiveRecord::RecordInvalid => exception
      fail(exception.message.to_sym)
    end    

    def user_products
      @user_products = []
      @user.orders.each { |order| @user_products = @user_products + order.products.pluck(:code) }
    end
      
    def return  
      { 
        user: {
          user_id: @user.username,
          data: {
            balance: @user.balances.sum(:amount),
            product_ids: @user_products.uniq
          }
        }
      }
    end
    
end