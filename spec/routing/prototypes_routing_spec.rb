require "rails_helper"

RSpec.describe PrototypesController, :type => :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/prototypes").to route_to("prototypes#index")
    end

    it "routes to #new" do
      expect(:get => "/prototypes/new").to route_to("prototypes#new")
    end

    it "routes to #show" do
      expect(:get => "/prototypes/1").to route_to("prototypes#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/prototypes/1/edit").to route_to("prototypes#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/prototypes").to route_to("prototypes#create")
    end

    it "routes to #update" do
      expect(:put => "/prototypes/1").to route_to("prototypes#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/prototypes/1").to route_to("prototypes#destroy", :id => "1")
    end

  end
end
