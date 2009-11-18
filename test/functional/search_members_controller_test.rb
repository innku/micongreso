require 'test_helper'

class SearchMembersControllerTest < ActionController::TestCase
  def test_index
    get :index
    assert_template 'index'
  end
  
  def test_show
    get :show, :id => SearchMembers.first
    assert_template 'show'
  end
  
  def test_new
    get :new
    assert_template 'new'
  end
  
  def test_create_invalid
    SearchMembers.any_instance.stubs(:valid?).returns(false)
    post :create
    assert_template 'new'
  end
  
  def test_create_valid
    SearchMembers.any_instance.stubs(:valid?).returns(true)
    post :create
    assert_redirected_to search_members_url(assigns(:search_members))
  end
  
  def test_edit
    get :edit, :id => SearchMembers.first
    assert_template 'edit'
  end
  
  def test_update_invalid
    SearchMembers.any_instance.stubs(:valid?).returns(false)
    put :update, :id => SearchMembers.first
    assert_template 'edit'
  end
  
  def test_update_valid
    SearchMembers.any_instance.stubs(:valid?).returns(true)
    put :update, :id => SearchMembers.first
    assert_redirected_to search_members_url(assigns(:search_members))
  end
  
  def test_destroy
    search_members = SearchMembers.first
    delete :destroy, :id => search_members
    assert_redirected_to search_members_url
    assert !SearchMembers.exists?(search_members.id)
  end
end
