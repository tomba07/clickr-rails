FactoryBot.define do
  factory :student_device_mapping do
    student
    school_class
    device_id { "rfid:#{Faker::Base.unique.regexify(/[abcde0-9]{8}/)}" }
    device_type { "rfid" }
  end
end
