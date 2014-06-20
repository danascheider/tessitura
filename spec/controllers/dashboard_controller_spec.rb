require 'rails_helper'

describe DashboardController do

  describe "GET 'index'" do
    before(:each) do 
      get :index
    end 

    it "returns http success" do
      response.should be_success
    end

    it "renders the dashboard view" do 
      expect(response).to render_template(:index)
    end
  end

end