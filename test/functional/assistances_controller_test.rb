require 'test_helper'

class AssistancesControllerTest < ActionController::TestCase
  def test_index
    get :index
    assert_template 'index'
  end
  
  def test_show
    get :show, :id => Assistance.first
    assert_template 'show'
  end
  
  def test_new
    get :new
    assert_template 'new'
  end
  
  def test_create_invalid
    Assistance.any_instance.stubs(:valid?).returns(false)
    post :create
    assert_template 'new'
  end
  
  def test_create_valid
    Assistance.any_instance.stubs(:valid?).returns(true)
    post :create
    assert_redirected_to assistance_url(assigns(:assistance))
  end
  
  def test_edit
    get :edit, :id => Assistance.first
    assert_template 'edit'
  end
  
  def test_update_invalid
    Assistance.any_instance.stubs(:valid?).returns(false)
    put :update, :id => Assistance.first
    assert_template 'edit'
  end
  
  def test_update_valid
    Assistance.any_instance.stubs(:valid?).returns(true)
    put :update, :id => Assistance.first
    assert_redirected_to assistance_url(assigns(:assistance))
  end
  
  def test_destroy
    assistance = Assistance.first
    delete :destroy, :id => assistance
    assert_redirected_to assistances_url
    assert !Assistance.exists?(assistance.id)
  end
end
