require 'test_helper'

class BillTest < ActiveSupport::TestCase
  def test_should_be_valid
    assert Bill.new.valid?
  end
end
