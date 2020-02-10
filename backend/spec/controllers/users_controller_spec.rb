require 'rails_helper'

RSpec.describe Api::UsersController, type: :controller do
  before(:each) { request.headers['Accept'] = "application/json" }

  context "when user is successfully created" do
    let(:user) { create(:user) }    

    before do     
      get :show, params: { id: user.username }, format: :json             
    end

    it { expect(response.status).to eq 200 } 
    it { expect(response.content_type).to eq "application/json; charset=utf-8" } 
    it { expect(json_response[:user][:user_id]).to eq user[:username] }
    it { expect(json_response[:user][:data][:balance]).to be >= 0 }
    it { expect(json_response[:user][:data][:product_ids]).to be_an_instance_of(Array) }
  end

  context "when user is invalid" do  
    before do     
      get :show, params: { id: "" }, format: :json      
    end

    it { expect(response.status).to eq 400 }
    it { expect(response.content_type).to eq "application/json; charset=utf-8" } 
    it { expect(json_response.has_key?(:error)).to be_truthy }
    it { expect(json_response[:error]).to eq "invalid_params_no_user_input"}
  end
end
