require 'test_helper'

class PartyTest < ActiveSupport::TestCase
  def test_should_be_valid
    assert Party.new.valid?
  end
end
