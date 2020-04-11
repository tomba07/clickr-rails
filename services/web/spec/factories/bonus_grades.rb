FactoryBot.define do
  factory :bonus_grade do
    school_class
    student { association :student, school_class: school_class }
    percentage { 1 }
  end
end
