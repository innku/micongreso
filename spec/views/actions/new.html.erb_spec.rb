require 'spec_helper'

describe "actions/new.html.erb" do
  before(:each) do
    assign(:action, stub_model(Action,
      :new_record? => true,
      :action_type => "MyString",
      :text => "MyText",
      :bill_id => 1
    ))
  end

  it "renders new action form" do
    render

    rendered.should have_selector("form", :action => actions_path, :method => "post") do |form|
      form.should have_selector("input#action_action_type", :name => "action[action_type]")
      form.should have_selector("textarea#action_text", :name => "action[text]")
      form.should have_selector("input#action_bill_id", :name => "action[bill_id]")
    end
  end
end
