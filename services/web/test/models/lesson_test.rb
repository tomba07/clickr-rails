require 'test_helper'

class LessonTest < ActiveSupport::TestCase
  def setup
    @school_class = create(:school_class)
    @student = create(:student, school_class: @school_class)
  end

  test 'with_participation_of returns only lessons with score above threshold' do
    lesson_with_score_1, lesson_with_score_0, lesson_with_score_minus_1 =
      create_list(:lesson, 3, school_class: @school_class)
    create(
      :question_response,
      lesson: lesson_with_score_1,
      school_class: @school_class,
      student: @student
    )
    create(
      :question_response,
      lesson: lesson_with_score_minus_1,
      score: -1,
      school_class: @school_class,
      student: @student
    )

    assert_equal [lesson_with_score_1, lesson_with_score_0],
                 Lesson.with_participation_of(student: @student)
  end
end
