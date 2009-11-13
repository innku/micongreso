require 'test_helper'

class PartiesControllerTest < ActionController::TestCase
  def test_index
    get :index
    assert_template 'index'
  end
  
  def test_show
    get :show, :id => Party.first
    assert_template 'show'
  end
  
  def test_new
    get :new
    assert_template 'new'
  end
  
  def test_create_invalid
    Party.any_instance.stubs(:valid?).returns(false)
    post :create
    assert_template 'new'
  end
  
  def test_create_valid
    Party.any_instance.stubs(:valid?).returns(true)
    post :create
    assert_redirected_to party_url(assigns(:party))
  end
  
  def test_edit
    get :edit, :id => Party.first
    assert_template 'edit'
  end
  
  def test_update_invalid
    Party.any_instance.stubs(:valid?).returns(false)
    put :update, :id => Party.first
    assert_template 'edit'
  end
  
  def test_update_valid
    Party.any_instance.stubs(:valid?).returns(true)
    put :update, :id => Party.first
    assert_redirected_to party_url(assigns(:party))
  end
  
  def test_destroy
    party = Party.first
    delete :destroy, :id => party
    assert_redirected_to parties_url
    assert !Party.exists?(party.id)
  end
end
