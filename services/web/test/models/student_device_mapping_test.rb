require 'test_helper'

class StudentDeviceMappingTest < ActiveSupport::TestCase
  def setup
    @school_class_one = create(:school_class)
    @oldest_complete =
      create(
        :student_device_mapping,
        device_id: '123', device_type: 'rfid', school_class: @school_class_one
      )
    @old_incomplete =
      create(
        :student_device_mapping,
        device_id: nil, device_type: 'nil', school_class: @school_class_one
      )
    @new_incomplete =
      create(:student_device_mapping, device_id: nil, device_type: 'nil')
  end

  test 'oldest_incomplete returns the mapping that was created first' do
    assert_equal @old_incomplete,
                 StudentDeviceMapping.oldest_incomplete('rfid:456')
  end

  test 'oldest_incomplete skips mappings if device_id is already mapped to school class' do
    assert_equal @new_incomplete,
                 StudentDeviceMapping.oldest_incomplete(
                   @oldest_complete.device_id
                 )
  end

  test 'nth_incomplete calculates correct 0-based index' do
    assert_nil @oldest_complete.nth_incomplete
    assert_equal 0, @old_incomplete.nth_incomplete
    assert_equal 1, @new_incomplete.nth_incomplete
  end
end
