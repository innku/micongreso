require 'test_helper'

class TermsControllerTest < ActionController::TestCase
  def test_index
    get :index
    assert_template 'index'
  end
  
  def test_show
    get :show, :id => Term.first
    assert_template 'show'
  end
  
  def test_new
    get :new
    assert_template 'new'
  end
  
  def test_create_invalid
    Term.any_instance.stubs(:valid?).returns(false)
    post :create
    assert_template 'new'
  end
  
  def test_create_valid
    Term.any_instance.stubs(:valid?).returns(true)
    post :create
    assert_redirected_to term_url(assigns(:term))
  end
  
  def test_edit
    get :edit, :id => Term.first
    assert_template 'edit'
  end
  
  def test_update_invalid
    Term.any_instance.stubs(:valid?).returns(false)
    put :update, :id => Term.first
    assert_template 'edit'
  end
  
  def test_update_valid
    Term.any_instance.stubs(:valid?).returns(true)
    put :update, :id => Term.first
    assert_redirected_to term_url(assigns(:term))
  end
  
  def test_destroy
    term = Term.first
    delete :destroy, :id => term
    assert_redirected_to terms_url
    assert !Term.exists?(term.id)
  end
end
