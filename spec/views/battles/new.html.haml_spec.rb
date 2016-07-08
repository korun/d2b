require 'rails_helper'

RSpec.describe "battles/new", :type => :view do
  before(:each) do
    assign(:battle, Battle.new())
  end

  it "renders new battle form" do
    render

    assert_select "form[action=?][method=?]", battles_path, "post" do
    end
  end
end
