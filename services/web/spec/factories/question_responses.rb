FactoryBot.define do
  factory :question_response do
    click
    student
    question
    lesson
    school_class
  end
end
