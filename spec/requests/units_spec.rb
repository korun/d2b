require 'rails_helper'

RSpec.describe "Units", :type => :request do
  describe "GET /units" do
    it "works! (now write some real specs)" do
      get units_path
      expect(response.status).to be(200)
    end
  end
end
