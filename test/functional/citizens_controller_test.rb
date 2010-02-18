require 'test_helper'

class CitizensControllerTest < ActionController::TestCase
  def test_index
    get :index
    assert_template 'index'
  end
  
  def test_show
    get :show, :id => Citizen.first
    assert_template 'show'
  end
  
  def test_new
    get :new
    assert_template 'new'
  end
  
  def test_create_invalid
    Citizen.any_instance.stubs(:valid?).returns(false)
    post :create
    assert_template 'new'
  end
  
  def test_create_valid
    Citizen.any_instance.stubs(:valid?).returns(true)
    post :create
    assert_redirected_to citizen_url(assigns(:citizen))
  end
  
  def test_edit
    get :edit, :id => Citizen.first
    assert_template 'edit'
  end
  
  def test_update_invalid
    Citizen.any_instance.stubs(:valid?).returns(false)
    put :update, :id => Citizen.first
    assert_template 'edit'
  end
  
  def test_update_valid
    Citizen.any_instance.stubs(:valid?).returns(true)
    put :update, :id => Citizen.first
    assert_redirected_to citizen_url(assigns(:citizen))
  end
  
  def test_destroy
    citizen = Citizen.first
    delete :destroy, :id => citizen
    assert_redirected_to citizens_url
    assert !Citizen.exists?(citizen.id)
  end
end
