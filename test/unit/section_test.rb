require 'test_helper'

class SectionTest < ActiveSupport::TestCase
  def test_should_be_valid
    assert Section.new.valid?
  end
end
