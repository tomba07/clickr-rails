require 'test_helper'

class LessonEvaluationTest < ActiveSupport::TestCase
  def setup
    school_class = create(:school_class)
    @students = create_list(:student, 3, school_class: school_class)
    lesson = create(:lesson, school_class: school_class)
    question = create(:question, school_class: school_class, lesson: lesson)
    create(
      :question_response,
      student: @students[0], question: question, lesson: lesson
    )
    @subject = Clickr::LessonEvaluation.new(lesson)
  end

  test 'max response count is 1' do
    assert_equal 1, @subject.max_question_response_sum
  end

  test 'min response count is 0' do
    assert_equal 0, @subject.min_question_response_sum
  end

  test 'highest response count is 1' do
    assert_equal 1, @subject.nth_highest_question_response_sum(n: 1)
  end

  test 'nth highest response count is 0 if N exceeds student count' do
    assert_equal 0,
                 @subject.nth_highest_question_response_sum(
                   n: @students.size + 1
                 )
  end
end
