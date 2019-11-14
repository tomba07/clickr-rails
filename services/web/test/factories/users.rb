FactoryBot.define do
  factory :user do
    email { Faker::Internet.unique.email }
    password { Faker::Internet.password }
    password_confirmation { password }
    school_class
  end
end
