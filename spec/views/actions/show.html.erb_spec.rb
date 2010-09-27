require 'spec_helper'

describe "actions/show.html.erb" do
  before(:each) do
    @action = assign(:action, stub_model(Action,
      :action_type => "Action Type",
      :text => "MyText",
      :bill_id => 1
    ))
  end

  it "renders attributes in <p>" do
    render
    rendered.should contain("Action Type".to_s)
    rendered.should contain("MyText".to_s)
    rendered.should contain(1.to_s)
  end
end
