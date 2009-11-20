require 'test_helper'

class BillsControllerTest < ActionController::TestCase
  def test_index
    get :index
    assert_template 'index'
  end
  
  def test_show
    get :show, :id => Bill.first
    assert_template 'show'
  end
  
  def test_new
    get :new
    assert_template 'new'
  end
  
  def test_create_invalid
    Bill.any_instance.stubs(:valid?).returns(false)
    post :create
    assert_template 'new'
  end
  
  def test_create_valid
    Bill.any_instance.stubs(:valid?).returns(true)
    post :create
    assert_redirected_to bill_url(assigns(:bill))
  end
  
  def test_edit
    get :edit, :id => Bill.first
    assert_template 'edit'
  end
  
  def test_update_invalid
    Bill.any_instance.stubs(:valid?).returns(false)
    put :update, :id => Bill.first
    assert_template 'edit'
  end
  
  def test_update_valid
    Bill.any_instance.stubs(:valid?).returns(true)
    put :update, :id => Bill.first
    assert_redirected_to bill_url(assigns(:bill))
  end
  
  def test_destroy
    bill = Bill.first
    delete :destroy, :id => bill
    assert_redirected_to bills_url
    assert !Bill.exists?(bill.id)
  end
end
