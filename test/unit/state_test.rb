require 'test_helper'

class StateTest < ActiveSupport::TestCase
  def test_should_be_valid
    assert State.new.valid?
  end
end
