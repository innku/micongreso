require 'test_helper'

class AssistanceTest < ActiveSupport::TestCase
  def test_should_be_valid
    assert Assistance.new.valid?
  end
end
