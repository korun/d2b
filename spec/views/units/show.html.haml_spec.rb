require 'rails_helper'

RSpec.describe "units/show", :type => :view do
  before(:each) do
    @unit = assign(:unit, Unit.create!())
  end

  xit "renders attributes in <p>" do
    render
  end
end
