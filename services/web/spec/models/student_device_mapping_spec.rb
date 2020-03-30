require 'rails_helper'

RSpec.describe StudentDeviceMapping do
  let(:school_class_one) { create(:school_class) }
  let!(:old_incomplete) {
    create(
      :student_device_mapping,
      device_id: nil, device_type: 'nil', school_class: school_class_one
    )
  }
  let!(:new_incomplete) {
    create(
      :student_device_mapping,
      device_id: nil, device_type: 'nil', school_class: school_class_one
    )
  }

  describe 'oldest_incomplete' do
    it 'returns the mapping that was created first' do
      expect(StudentDeviceMapping.oldest_incomplete(
                     'rfid:456',
                     school_class_one
                   )).to eq old_incomplete
    end

    it 'returns nil if already mapped to class' do
      complete =
        create(
          :student_device_mapping,
          device_id: '123', device_type: 'rfid', school_class: school_class_one
        )
      expect(StudentDeviceMapping.oldest_incomplete(
                   complete.device_id,
                   school_class_one
                 )).to be_nil
    end
  end

  describe 'nth_incomplete' do
    it 'calculates correct 0-based index' do
      expect(old_incomplete.nth_incomplete(school_class_one)).to eq 0
      expect(new_incomplete.nth_incomplete(school_class_one)).to eq 1
    end
  end
end
