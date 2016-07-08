require 'rails_helper'

RSpec.describe "prototypes/show", :type => :view do
  before(:each) do
    @prototype = assign(:prototype, Prototype.create!())
  end

  it "renders attributes in <p>" do
    render
  end
end
