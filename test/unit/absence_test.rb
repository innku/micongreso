require 'test_helper'

class AbsenceTest < ActiveSupport::TestCase
  def test_should_be_valid
    assert Absence.new.valid?
  end
end
