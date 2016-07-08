require 'rails_helper'

RSpec.describe "prototypes/edit", :type => :view do
  before(:each) do
    @prototype = assign(:prototype, Prototype.create!())
  end

  it "renders the edit prototype form" do
    render

    assert_select "form[action=?][method=?]", prototype_path(@prototype), "post" do
    end
  end
end
