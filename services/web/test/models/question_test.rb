require 'test_helper'

class QuestionTest < ActiveSupport::TestCase
  test 'default_name uses count for first question' do
    school_class = create(:school_class)
    lesson = school_class.lessons.create!(name: 'L1')

    assert_equal 'Question 1', Question.default_name(lesson)
  end

  test 'default_name uses count for second question' do
    school_class = create(:school_class)
    lesson = school_class.lessons.create!(name: 'L1')
    lesson.questions.create!(school_class: school_class, name: "Q1")

    assert_equal 'Question 2', Question.default_name(lesson)
  end
end
