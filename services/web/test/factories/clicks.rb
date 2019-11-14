FactoryBot.define do
  factory :click do
    device_type { 'rfid' }
    device_id { "rfid:#{Faker::Base.regexify(/[abcde0-9]{8}/)}" }
  end
end
