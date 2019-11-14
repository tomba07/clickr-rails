FactoryBot.define do
  factory :question do
    school_class
    lesson
    sequence(:name) { |n| "Question #{n}" }
  end
end
