require 'rails_helper'

RSpec.describe "prototypes/new", :type => :view do
  before(:each) do
    assign(:prototype, Prototype.new())
  end

  it "renders new prototype form" do
    render

    assert_select "form[action=?][method=?]", prototypes_path, "post" do
    end
  end
end
