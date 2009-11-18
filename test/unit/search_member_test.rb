require 'test_helper'

class SearchMemberTest < ActiveSupport::TestCase
  def test_should_be_valid
    assert SearchMembers.new.valid?
  end
end
