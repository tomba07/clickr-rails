FactoryBot.define do
  factory :student_device_mapping do
    school_class
    student { association :student, school_class: school_class }
    sequence(:device_id) { |n| "rfid:#{n}" }
    device_type { 'rfid' }
  end
end
