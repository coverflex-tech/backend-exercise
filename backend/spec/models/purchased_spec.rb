require 'rails_helper'

RSpec.describe Purchased, type: :model do
  let(:user) { create(:user) }
  let(:order) { build(:order, user_id: user&.id) }  
  let(:product) { build(:product) }
  let(:purchased) { build(:purchased, order_id: order&.id, product_id: product&.id) }

  subject { purchased }

  it { should respond_to :order_id }
  it { should respond_to :product_id }

  it { should belong_to :order }
  it { should belong_to :product }

end
