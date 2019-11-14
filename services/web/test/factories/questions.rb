FactoryBot.define do
  factory :question do
    school_class
    lesson
    name { Faker::Lorem.unique.sentence }
  end
end
