require 'test_helper'

class RegionsControllerTest < ActionController::TestCase
  def test_show
    get :show, :id => Region.first
    assert_template 'show'
  end
end
