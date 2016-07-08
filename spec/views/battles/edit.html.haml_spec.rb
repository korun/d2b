require 'rails_helper'

RSpec.describe "battles/edit", :type => :view do
  before(:each) do
    @battle = assign(:battle, Battle.create!())
  end

  it "renders the edit battle form" do
    render

    assert_select "form[action=?][method=?]", battle_path(@battle), "post" do
    end
  end
end
