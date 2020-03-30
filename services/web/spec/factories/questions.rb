FactoryBot.define do
  factory :question do
    school_class
    lesson { association :lesson, school_class: school_class }
    sequence(:name) { |n| "Question #{n}" }
  end
end
