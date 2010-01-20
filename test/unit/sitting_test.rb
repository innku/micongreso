require 'test_helper'

class SittingTest < ActiveSupport::TestCase
  def test_should_be_valid
    assert Sitting.new.valid?
  end
end
