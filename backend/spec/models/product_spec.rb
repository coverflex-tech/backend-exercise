require 'rails_helper'

RSpec.describe Product, type: :model do

  context 'when product is not valid' do  
    let(:product) { "" }

    it { should_not be_valid }
  end  
  
  context 'when validating product' do  
    let(:product) { build(:product) }
  
    subject { product }    
  
    it { should be_valid }    
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:price) }
    it { should validate_numericality_of(:price).is_greater_than_or_equal_to(0) }
    it { should allow_value(Faker::Alphanumeric.alpha(number: 15).downcase).for(:code) }
    it { should allow_value(Faker::Company.name).for(:name) }
    it { should allow_value(rand(-100)).for(:price) }
    it { should have_many(:purchaseds) }
  it { should have_many(:orders).through(:purchaseds) }    
  end

end
