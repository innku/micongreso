require 'spec_helper'

describe ActionsController do

  def mock_action(stubs={})
    @mock_action ||= mock_model(Action, stubs).as_null_object
  end

  describe "GET index" do
    it "assigns all actions as @actions" do
      Action.stub(:all) { [mock_action] }
      get :index
      assigns(:actions).should eq([mock_action])
    end
  end

  describe "GET show" do
    it "assigns the requested action as @action" do
      Action.stub(:find).with("37") { mock_action }
      get :show, :id => "37"
      assigns(:action).should be(mock_action)
    end
  end

  describe "GET new" do
    it "assigns a new action as @action" do
      Action.stub(:new) { mock_action }
      get :new
      assigns(:action).should be(mock_action)
    end
  end

  describe "GET edit" do
    it "assigns the requested action as @action" do
      Action.stub(:find).with("37") { mock_action }
      get :edit, :id => "37"
      assigns(:action).should be(mock_action)
    end
  end

  describe "POST create" do

    describe "with valid params" do
      it "assigns a newly created action as @action" do
        Action.stub(:new).with({'these' => 'params'}) { mock_action(:save => true) }
        post :create, :action => {'these' => 'params'}
        assigns(:action).should be(mock_action)
      end

      it "redirects to the created action" do
        Action.stub(:new) { mock_action(:save => true) }
        post :create, :action => {}
        response.should redirect_to(action_url(mock_action))
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved action as @action" do
        Action.stub(:new).with({'these' => 'params'}) { mock_action(:save => false) }
        post :create, :action => {'these' => 'params'}
        assigns(:action).should be(mock_action)
      end

      it "re-renders the 'new' template" do
        Action.stub(:new) { mock_action(:save => false) }
        post :create, :action => {}
        response.should render_template("new")
      end
    end

  end

  describe "PUT update" do

    describe "with valid params" do
      it "updates the requested action" do
        Action.should_receive(:find).with("37") { mock_action }
        mock_action.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :action => {'these' => 'params'}
      end

      it "assigns the requested action as @action" do
        Action.stub(:find) { mock_action(:update_attributes => true) }
        put :update, :id => "1"
        assigns(:action).should be(mock_action)
      end

      it "redirects to the action" do
        Action.stub(:find) { mock_action(:update_attributes => true) }
        put :update, :id => "1"
        response.should redirect_to(action_url(mock_action))
      end
    end

    describe "with invalid params" do
      it "assigns the action as @action" do
        Action.stub(:find) { mock_action(:update_attributes => false) }
        put :update, :id => "1"
        assigns(:action).should be(mock_action)
      end

      it "re-renders the 'edit' template" do
        Action.stub(:find) { mock_action(:update_attributes => false) }
        put :update, :id => "1"
        response.should render_template("edit")
      end
    end

  end

  describe "DELETE destroy" do
    it "destroys the requested action" do
      Action.should_receive(:find).with("37") { mock_action }
      mock_action.should_receive(:destroy)
      delete :destroy, :id => "37"
    end

    it "redirects to the actions list" do
      Action.stub(:find) { mock_action }
      delete :destroy, :id => "1"
      response.should redirect_to(actions_url)
    end
  end

end
