require 'rails_helper'

RSpec.describe Api::ProductsController, type: :controller do

  context "when a list of products is successfully listed" do
    let!(:product) { create(:product) }    

    before do     
        get :index, format: :json                 
    end

    it { expect(response.status).to eq 200 } 
    it { expect(response.content_type).to eq "application/json; charset=utf-8" } 
    it { expect(json_response[:products]).to be_an_instance_of(Array) }
    it { expect(json_response[:products].length).to eq(1)}
    it { expect(json_response[:products][0][:id]).not_to be_empty }
    it { expect(json_response[:products][0][:name]).not_to be_empty }
    it { expect(json_response[:products][0][:price].to_f).to be > 0 }
  end

end
