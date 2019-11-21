require 'test_helper'

class StudentDeviceMappingTest < ActiveSupport::TestCase
  test 'oldest_incomplete returns the mapping that was created first' do
    oldest_complete = create(:student_device_mapping, device_id: '123', device_type: 'rfid')
    old_incomplete = create(:student_device_mapping, device_id: nil, device_type: 'nil')
    new_incomplete = create(:student_device_mapping, device_id: nil, device_type: 'nil')

    assert_equal old_incomplete, StudentDeviceMapping.oldest_incomplete
  end
end
