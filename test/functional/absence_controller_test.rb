require 'test_helper'

class AbsencesControllerTest < ActionController::TestCase
  def test_index
    get :index
    assert_template 'index'
  end
  
  def test_show
    get :show, :id => Absence.first
    assert_template 'show'
  end
  
  def test_new
    get :new
    assert_template 'new'
  end
  
  def test_create_invalid
    Absence.any_instance.stubs(:valid?).returns(false)
    post :create
    assert_template 'new'
  end
  
  def test_create_valid
    Absence.any_instance.stubs(:valid?).returns(true)
    post :create
    assert_redirected_to absence_url(assigns(:absence))
  end
  
  def test_edit
    get :edit, :id => Absence.first
    assert_template 'edit'
  end
  
  def test_update_invalid
    Absence.any_instance.stubs(:valid?).returns(false)
    put :update, :id => Absence.first
    assert_template 'edit'
  end
  
  def test_update_valid
    Absence.any_instance.stubs(:valid?).returns(true)
    put :update, :id => Absence.first
    assert_redirected_to absence_url(assigns(:absence))
  end
  
  def test_destroy
    absence = Absence.first
    delete :destroy, :id => absence
    assert_redirected_to absences_url
    assert !Absence.exists?(absence.id)
  end
end
