class PlaceOrder
  include Interactor

  def call
    subtract_order_price(context.user, context.total)
    order = create_order(context.user, context.total)
    context.products.each { |product| create_order_product(product, order) }

    order
  end

  private

  def subtract_order_price(user, total)
    user.balance -= total
    user.balance = user.balance
    user.save
  end

  def create_order(user, total)
    Order.create(user: user, total: total)
  end

  def create_order_product(product, order)
    OrderProduct.create(product: product, order: order)
  end
end
