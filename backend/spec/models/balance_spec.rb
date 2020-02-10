require 'rails_helper'

RSpec.describe Balance, type: :model do
  
  context 'when validating product' do  
    let!(:user) { create(:user) }
    let(:balance) { build(:balance, user_id: user&.id) }
  
    subject { balance }    
  
    it { should be_valid }    
    it { should validate_presence_of(:user_id) }    
    it { should validate_numericality_of(:amount).is_greater_than_or_equal_to(0) }    
    it { should allow_value(rand(-100)).for(:amount) }    
  end
end
