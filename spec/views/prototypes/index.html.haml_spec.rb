require 'rails_helper'

RSpec.describe "prototypes/index", :type => :view do
  before(:each) do
    assign(:prototypes, [
      Prototype.create!(),
      Prototype.create!()
    ])
  end

  it "renders a list of prototypes" do
    render
  end
end
