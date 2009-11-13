require 'test_helper'

class StatesControllerTest < ActionController::TestCase
  def test_index
    get :index
    assert_template 'index'
  end
  
  def test_show
    get :show, :id => State.first
    assert_template 'show'
  end
  
  def test_new
    get :new
    assert_template 'new'
  end
  
  def test_create_invalid
    State.any_instance.stubs(:valid?).returns(false)
    post :create
    assert_template 'new'
  end
  
  def test_create_valid
    State.any_instance.stubs(:valid?).returns(true)
    post :create
    assert_redirected_to state_url(assigns(:state))
  end
  
  def test_edit
    get :edit, :id => State.first
    assert_template 'edit'
  end
  
  def test_update_invalid
    State.any_instance.stubs(:valid?).returns(false)
    put :update, :id => State.first
    assert_template 'edit'
  end
  
  def test_update_valid
    State.any_instance.stubs(:valid?).returns(true)
    put :update, :id => State.first
    assert_redirected_to state_url(assigns(:state))
  end
  
  def test_destroy
    state = State.first
    delete :destroy, :id => state
    assert_redirected_to states_url
    assert !State.exists?(state.id)
  end
end
