require 'rails_helper'

RSpec.describe Api::OrdersController, type: :controller do

    context "when creating a valid order" do
      let(:user) { create(:user) }
      let(:product) { create(:product) }  
      let(:params) { {"order": {"items": [product.code], "user_id": user.username}} }  
  
      before do     
          post :create, params: params, format: :json            
      end
  
      it { expect(response.status).to eq 200 } 
      it { expect(response.content_type).to eq "application/json; charset=utf-8" } 
      it { expect(json_response[:order][:data][:items]).to be_an_instance_of(Array) }
      it { expect(json_response[:order][:data][:items].length).to eq(1)}
      it { expect(json_response[:order][:data][:total].to_f).to be > 0 }
      it { expect(json_response[:order][:order_id]).to be > 0 }
    end

    context "when creating a invalid order without products" do
      let(:user) { create(:user) }      
      let(:params) { {"order": {"items": [], "user_id": user.username}} }  
  
      before do     
          post :create, params: params, format: :json                      
      end      
  
      it { expect(response.status).to eq 400 } 
      it { expect(response.content_type).to eq "application/json; charset=utf-8" } 
      it { expect(json_response.has_key?(:error)).to be_truthy }
      it { expect(json_response[:error]).to eq "products_not_found"}
    end

    context "when products already purchased" do
      let(:user) { create(:user) }
      let(:product) { create(:product) }  
      let(:params) { {"order": {"items": [product.code], "user_id": user.username}} }  
  
      before do
        2.times do
          post :create, params: params, format: :json
        end
      end      
  
      it { expect(response.status).to eq 400 } 
      it { expect(response.content_type).to eq "application/json; charset=utf-8" } 
      it { expect(json_response.has_key?(:error)).to be_truthy }
      it { expect(json_response[:error]).to eq "products_already_purchased"}
    end

    context "when creating a invalid no balance" do
      let(:user) { create(:user) }
      let(:product) { create(:product, price: user.balances.sum(:amount) + 500) }  
      let(:params) { {"order": {"items": [product.code], "user_id": user.username}} }  
  
      before do     
          post :create, params: params, format: :json                      
      end      
  
      it { expect(response.status).to eq 400 } 
      it { expect(response.content_type).to eq "application/json; charset=utf-8" } 
      it { expect(json_response.has_key?(:error)).to be_truthy }
      it { expect(json_response[:error]).to eq "insufficient_balance"}
    end

end
