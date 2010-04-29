require 'test_helper'

class TermTest < ActiveSupport::TestCase
  def test_should_be_valid
    assert Term.new.valid?
  end
end
