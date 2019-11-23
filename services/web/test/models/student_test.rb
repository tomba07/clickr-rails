require 'test_helper'

class StudentTest < ActiveSupport::TestCase
  test 'question_response_sum sums up all scores' do
    student = create(:student)
    student.question_responses << (1..5).to_a.map { create(:question_response) }

    assert_equal 5, student.question_response_sum
  end

  test 'question_response_sum_for_most_recent_lesson sums up all scores only for questions in most recent lesson' do
    school_class = create(:school_class)
    student = create(:student, school_class: school_class)
    school_class.lessons << (old_lesson, most_recent_lesson = [create(:lesson), create(:lesson)])
    old_lesson.question_responses << (1..3).to_a.map { create(:question_response, student: student) }
    most_recent_lesson.question_responses << (1..5).to_a.map { create(:question_response, student: student) }

    assert_equal 5, student.question_response_sum_for_most_recent_lesson
  end
end
