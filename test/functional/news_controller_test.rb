require 'test_helper'

class NewsControllerTest < ActionController::TestCase
  def test_index
    get :index
    assert_template 'index'
  end
  
  def test_show
    get :show, :id => News.first
    assert_template 'show'
  end
  
  def test_new
    get :new
    assert_template 'new'
  end
  
  def test_create_invalid
    News.any_instance.stubs(:valid?).returns(false)
    post :create
    assert_template 'new'
  end
  
  def test_create_valid
    News.any_instance.stubs(:valid?).returns(true)
    post :create
    assert_redirected_to news_url(assigns(:news))
  end
  
  def test_edit
    get :edit, :id => News.first
    assert_template 'edit'
  end
  
  def test_update_invalid
    News.any_instance.stubs(:valid?).returns(false)
    put :update, :id => News.first
    assert_template 'edit'
  end
  
  def test_update_valid
    News.any_instance.stubs(:valid?).returns(true)
    put :update, :id => News.first
    assert_redirected_to news_url(assigns(:news))
  end
  
  def test_destroy
    news = News.first
    delete :destroy, :id => news
    assert_redirected_to news_url
    assert !News.exists?(news.id)
  end
end
