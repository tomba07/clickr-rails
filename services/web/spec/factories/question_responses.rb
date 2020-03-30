FactoryBot.define do
  factory :question_response do
    click
    school_class
    student { association :student, school_class: school_class }
    lesson { association :lesson, school_class: school_class }
    question { association :question, school_class: school_class, lesson: lesson }
  end
end
