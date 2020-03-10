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
  end

  test 'max response count is 1' do
    subject = Clickr::LessonEvaluation.new(@lesson)
    assert_equal 1, subject.max_question_response_sum
  end

  test 'min response count is 1 (ignores 0 responses, assuming the student was missing)' do
    subject = Clickr::LessonEvaluation.new(@lesson)
    assert_equal 1, subject.min_question_response_sum
  end

  test 'min response count is 1 (the lowest non-zero response count)' do
    create(
      :question_response,
      student: @students[1], question: @question, lesson: @lesson
    )
    question2 = create(:question, school_class: @school_class, lesson: @lesson)
    create(
      :question_response,
      student: @students[0], question: question2, lesson: @lesson
    )

    subject = Clickr::LessonEvaluation.new(@lesson)
    assert_equal 1, subject.min_question_response_sum
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

  test 'average percentage is 100% (ignores zero response counts)' do
    subject = Clickr::LessonEvaluation.new(@lesson)
    assert_equal 1.0, subject.average_percentage
  end

  test 'average percentage is 75% (ignores zero response counts)' do
    create(
      :question_response,
      student: @students[1], question: @question, lesson: @lesson
    )
    question2 = create(:question, school_class: @school_class, lesson: @lesson)
    create(
      :question_response,
      student: @students[0], question: question2, lesson: @lesson
    )
    @lesson.update!(benchmark: 2)

    subject = Clickr::LessonEvaluation.new(@lesson)
    assert_equal 0.75, subject.average_percentage
  end
end
