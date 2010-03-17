require 'test_helper'

class ProfilesControllerTest < ActionController::TestCase
  def test_create_invalid
    Profile.any_instance.stubs(:valid?).returns(false)
    post :create
    assert_template 'new'
  end
  
  def test_create_valid
    Profile.any_instance.stubs(:valid?).returns(true)
    post :create
    assert_redirected_to root_url
  end
  
  def test_update_invalid
    Profile.any_instance.stubs(:valid?).returns(false)
    put :update, :id => Profile.first
    assert_template 'edit'
  end
  
  def test_update_valid
    Profile.any_instance.stubs(:valid?).returns(true)
    put :update, :id => Profile.first
    assert_redirected_to root_url
  end
end
