require 'rails_helper'

RSpec.describe "units/index", :type => :view do
  before(:each) do
    assign(:units, [
      Unit.create!(),
      Unit.create!()
    ])
  end

  xit "renders a list of units" do
    render
  end
end
