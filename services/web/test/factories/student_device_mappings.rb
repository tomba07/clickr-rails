FactoryBot.define do
  factory :student_device_mapping do
    student
    school_class
    sequence(:device_id) { |n| "rfid:#{n}" }
    device_type { 'rfid' }
  end
end
