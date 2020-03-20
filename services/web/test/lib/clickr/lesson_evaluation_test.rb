require 'test_helper'

class LessonEvaluationTest < ActiveSupport::TestCase
  def setup
    @school_class = create(:school_class)
    @students = create_list(:student, 3, school_class: @school_class)
    @lesson = create(:lesson, school_class: @school_class)
    @question = create(:question, school_class: @school_class, lesson: @lesson)
    create(
      :question_response,
      student: @students[0], question: @question, lesson: @lesson
    )
    create(
      :question_response,
      student: @students[1], score: -1, question: @question, lesson: @lesson
    )
    create(
      :question_response,
      student: @students[2], score: -1, question: @question, lesson: @lesson
    )
  end

  test 'max response count is 1' do
    subject = Clickr::LessonEvaluation.new(@lesson)
    assert_equal 1, subject.max_question_response_sum
  end

  test 'min response count is 0 (the lowest count above the participation threshold)' do
    create(:question_response, student: @students[1], lesson: @lesson)

    subject = Clickr::LessonEvaluation.new(@lesson)
    assert_equal 0, subject.min_question_response_sum
  end

  test 'highest response count is 1' do
    subject = Clickr::LessonEvaluation.new(@lesson)
    assert_equal 1, subject.nth_highest_question_response_sum(n: 1)
  end

  test 'nth highest response count is 1 if N exceeds student count' do
    subject = Clickr::LessonEvaluation.new(@lesson)
    assert_equal 1,
                 subject.nth_highest_question_response_sum(
                   n: @students.size + 1
                 )
  end

  test 'average percentage is 100% (ignores absent students)' do
    subject = Clickr::LessonEvaluation.new(@lesson)
    assert_equal 1.0, subject.average_percentage
  end

  test 'average percentage is 75% ((2 + 1) / 2) (ignores absent students)' do
    other_student = create(:student, school_class: @school_class)
    create(:question_response, student: @students[0], lesson: @lesson)
    create(:question_response, student: other_student, lesson: @lesson)

    @lesson.update!(benchmark: 2)

    subject = Clickr::LessonEvaluation.new(@lesson)
    assert_equal 0.75, subject.average_percentage
  end
end
