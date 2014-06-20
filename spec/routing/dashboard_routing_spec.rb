require 'spec_helper'

describe DashboardController do 
  describe "index route" do 
    it "routes to index" do 
      expect(get("/dashboard/index")).to route_to("dashboard#index")
    end
  end

  describe "root route" do 
    it "directs to index" do 
      expect(get("/")).to route_to("dashboard#index")
    end
  end
end