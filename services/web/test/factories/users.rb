FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "f+#{n}@ftes.de" }
    password { 'password' }
    password_confirmation { 'password' }
    school_class
  end
end
