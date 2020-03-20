require 'test_helper'

class GradeTest < ActiveSupport::TestCase
  [
    [100, '1+'],
    [98, '1+'],
    [97, '1'],
    [95, '1'],
    [92, '1-'],
    [78, '2-'],
    [37, '5'],
    [25, '5-'],
    [0, '6']
  ].each do |percent, grade|
    test "GRADING_TABLE maps #{percent}% to #{grade}" do
      assert_equal grade, Clickr::Grade::GRADING_TABLE[percent]
    end
  end

  test 'from_percentage converts 0.77 to 2-' do
    assert_equal '2-', Clickr::Grade.from_percentage(0.77)
  end
end
