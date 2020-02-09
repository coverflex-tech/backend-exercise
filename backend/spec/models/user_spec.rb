require 'rails_helper'

RSpec.describe User, type: :model do  
  
  context 'when user is not valid' do  
    let(:user) { "" }

    it { should_not be_valid }
  end
  
  context 'when validating user' do      
    let(:user) { build(:user) }

    subject { user }

    it { should respond_to(:username) }
    it { should be_valid }
    it { should validate_presence_of(:username) }
    it { should validate_uniqueness_of(:username) }
    it { should allow_value(Faker::Alphanumeric.alpha(number: 15).downcase).for(:username) }
  end
end
