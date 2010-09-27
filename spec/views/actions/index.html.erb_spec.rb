require 'spec_helper'

describe "actions/index.html.erb" do
  before(:each) do
    assign(:actions, [
      stub_model(Action,
        :action_type => "Action Type",
        :text => "MyText",
        :bill_id => 1
      ),
      stub_model(Action,
        :action_type => "Action Type",
        :text => "MyText",
        :bill_id => 1
      )
    ])
  end

  it "renders a list of actions" do
    render
    rendered.should have_selector("tr>td", :content => "Action Type".to_s, :count => 2)
    rendered.should have_selector("tr>td", :content => "MyText".to_s, :count => 2)
    rendered.should have_selector("tr>td", :content => 1.to_s, :count => 2)
  end
end
