require 'test_helper'

class StudentDeviceMappingTest < ActiveSupport::TestCase
  def setup
    @oldest_complete = create(:student_device_mapping, device_id: '123', device_type: 'rfid')
    @old_incomplete = create(:student_device_mapping, device_id: nil, device_type: 'nil')
    @new_incomplete = create(:student_device_mapping, device_id: nil, device_type: 'nil')
  end

  test 'oldest_incomplete returns the mapping that was created first' do
    assert_equal @old_incomplete, StudentDeviceMapping.oldest_incomplete
  end

  test 'nth_incomplete calculates correct 0-based index' do
    assert_nil @oldest_complete.nth_incomplete
    assert_equal 0, @old_incomplete.nth_incomplete
    assert_equal 1, @new_incomplete.nth_incomplete
  end
end
