require "spec_helper"

describe ActionsController do
  describe "routing" do

    it "recognizes and generates #index" do
      { :get => "/actions" }.should route_to(:controller => "actions", :action => "index")
    end

    it "recognizes and generates #new" do
      { :get => "/actions/new" }.should route_to(:controller => "actions", :action => "new")
    end

    it "recognizes and generates #show" do
      { :get => "/actions/1" }.should route_to(:controller => "actions", :action => "show", :id => "1")
    end

    it "recognizes and generates #edit" do
      { :get => "/actions/1/edit" }.should route_to(:controller => "actions", :action => "edit", :id => "1")
    end

    it "recognizes and generates #create" do
      { :post => "/actions" }.should route_to(:controller => "actions", :action => "create")
    end

    it "recognizes and generates #update" do
      { :put => "/actions/1" }.should route_to(:controller => "actions", :action => "update", :id => "1")
    end

    it "recognizes and generates #destroy" do
      { :delete => "/actions/1" }.should route_to(:controller => "actions", :action => "destroy", :id => "1")
    end

  end
end
