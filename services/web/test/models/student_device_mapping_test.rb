require 'test_helper'

class StudentDeviceMappingTest < ActiveSupport::TestCase
  def setup
    @school_class_one = create(:school_class)
    @old_incomplete =
      create(
        :student_device_mapping,
        device_id: nil, device_type: 'nil', school_class: @school_class_one
      )
    @new_incomplete =
      create(
        :student_device_mapping,
        device_id: nil, device_type: 'nil', school_class: @school_class_one
      )
  end

  test 'oldest_incomplete returns the mapping that was created first' do
    assert_equal @old_incomplete,
                 StudentDeviceMapping.oldest_incomplete(
                   'rfid:456',
                   @school_class_one
                 )
  end

  test 'oldest_incomplete returns nil if already mapped to class' do
    complete =
      create(
        :student_device_mapping,
        device_id: '123', device_type: 'rfid', school_class: @school_class_one
      )
    assert_nil StudentDeviceMapping.oldest_incomplete(
                 complete.device_id,
                 @school_class_one
               )
  end

  test 'nth_incomplete calculates correct 0-based index' do
    assert_equal 0, @old_incomplete.nth_incomplete(@school_class_one)
    assert_equal 1, @new_incomplete.nth_incomplete(@school_class_one)
  end
end
