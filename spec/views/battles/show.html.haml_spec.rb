require 'rails_helper'

RSpec.describe "battles/show", :type => :view do
  before(:each) do
    @battle = assign(:battle, Battle.create!())
  end

  it "renders attributes in <p>" do
    render
  end
end
