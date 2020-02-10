class OrderCreate < BusinessProcess::Base

    # Specify requirements    
    needs :params    
  
    steps :init,
          :validate_data,                    
          :check_products_exists,
          :already_purchased,         
          :check_balance,
          :create_order,
          :return    

    def init
      @order = nil
      @user = User.find_by(username: ActiveSupport::Inflector.transliterate(params[:order][:user_id].downcase.sub(/\s+/, '').to_s))
      @products = Product.where(code: params[:order][:items])
      @total = @products.sum(:price)
    end
  
    def validate_data      
      fail(:invalid_params) if params.nil?
      fail(:invalid_user) if @user.nil?
      fail(:products_not_found) if @products.nil? || @products.blank?
    end    

    def check_products_exists
      product_available = Product.all.pluck(:code)  
      unless params[:order][:items].nil?
        params[:order][:items].each { |pr| fail(:products_not_found) unless product_available.include?(pr) }       
      end
    end

    def already_purchased 
      unless @user.orders.nil?     
        @user.orders.each do |order|
          fail(:products_already_purchased) unless order.products.where(code: params[:order][:items]).empty?
        end      
      end
    end

    def check_balance
      fail(:insufficient_balance) if @user.balances.sum(:amount) < @total
    end

    def create_order
      ActiveRecord::Base.transaction do
        @order = Order.create!(user: @user, total: @total)
        @products.each do |product|          
          Purchased.create!(order: @order, product: product)
        end
      end
    rescue ActiveRecord::RecordInvalid => exception
      fail(exception.message.to_sym)      
    end
      
    def return  
      {
        order: {
          order_id: @order.id,
          data: {
            items: params[:order][:items],
            total: @total 
          }
        }
      }
    end
    
end