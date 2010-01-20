require 'test_helper'

class SittingsControllerTest < ActionController::TestCase
  def test_index
    get :index
    assert_template 'index'
  end
  
  def test_show
    get :show, :id => Sitting.first
    assert_template 'show'
  end
  
  def test_new
    get :new
    assert_template 'new'
  end
  
  def test_create_invalid
    Sitting.any_instance.stubs(:valid?).returns(false)
    post :create
    assert_template 'new'
  end
  
  def test_create_valid
    Sitting.any_instance.stubs(:valid?).returns(true)
    post :create
    assert_redirected_to sitting_url(assigns(:sitting))
  end
  
  def test_edit
    get :edit, :id => Sitting.first
    assert_template 'edit'
  end
  
  def test_update_invalid
    Sitting.any_instance.stubs(:valid?).returns(false)
    put :update, :id => Sitting.first
    assert_template 'edit'
  end
  
  def test_update_valid
    Sitting.any_instance.stubs(:valid?).returns(true)
    put :update, :id => Sitting.first
    assert_redirected_to sitting_url(assigns(:sitting))
  end
  
  def test_destroy
    sitting = Sitting.first
    delete :destroy, :id => sitting
    assert_redirected_to sittings_url
    assert !Sitting.exists?(sitting.id)
  end
end
