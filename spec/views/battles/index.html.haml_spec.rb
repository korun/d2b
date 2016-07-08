require 'rails_helper'

RSpec.describe "battles/index", :type => :view do
  before(:each) do
    assign(:battles, [
      Battle.create!(),
      Battle.create!()
    ])
  end

  it "renders a list of battles" do
    render
  end
end
