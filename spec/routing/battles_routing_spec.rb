require "rails_helper"

RSpec.describe BattlesController, :type => :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/battles").to route_to("battles#index")
    end

    it "routes to #new" do
      expect(:get => "/battles/new").to route_to("battles#new")
    end

    it "routes to #show" do
      expect(:get => "/battles/1").to route_to("battles#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/battles/1/edit").to route_to("battles#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/battles").to route_to("battles#create")
    end

    it "routes to #update" do
      expect(:put => "/battles/1").to route_to("battles#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/battles/1").to route_to("battles#destroy", :id => "1")
    end

  end
end
