require 'test_helper'

class StudentTest < ActiveSupport::TestCase
  def setup
    @school_class = create(:school_class)
    @student = create(:student, school_class: @school_class)
  end

  test 'question_response_sum sums up all scores' do
    @student.question_responses <<
      (1..5).to_a.map { create(:question_response) }

    assert_equal 5, @student.question_response_sum
  end

  test 'question_response_sum_for_most_recent_lesson sums up all scores only for questions in most recent lesson' do
    @school_class.lessons <<
      (old_lesson, most_recent_lesson = [create(:lesson), create(:lesson)])
    old_lesson.question_responses <<
      (1..3).to_a.map { create(:question_response, student: @student) }
    most_recent_lesson.question_responses <<
      (1..5).to_a.map { create(:question_response, student: @student) }

    assert_equal 5, @student.question_response_sum_for_most_recent_lesson
  end

  test 'nth_incomplete_mapping selects oldest incomplete mapping' do
    @student.student_device_mappings.create!(school_class: @school_class)
    @student.student_device_mappings.create!(school_class: @school_class)

    other_student = create(:student)
    other_student.student_device_mappings.create!(school_class: @school_class)

    assert_equal 0, @student.nth_incomplete_mapping
    assert_equal 2, other_student.nth_incomplete_mapping
  end

  test 'nth_incomplete_mapping returns nil if no incomplete mapping exists' do
    @student.student_device_mappings.create!(
      school_class: @school_class, device_type: 'rfid', device_id: '1'
    )

    assert_nil @student.nth_incomplete_mapping
  end

  test 'responded_to_most_recent_question returns true if student responded' do
    lesson = @school_class.most_recent_lesson_or_create
    question =
      lesson.questions.create!(school_class: @school_class, name: 'Question')
    click = create(:click)
    @student.question_responses.create!(
      school_class: @school_class,
      lesson: lesson,
      question: question,
      click: click
    )

    assert_equal true, @student.responded_to_most_recent_question
  end

  test 'responded_to_most_recent_question returns false if student did not respond' do
    lesson = @school_class.most_recent_lesson_or_create
    question =
      lesson.questions.create!(school_class: @school_class, name: 'Question')

    assert_equal false, @student.responded_to_most_recent_question
  end

  test 'responded_to_most_recent_question returns false if only a virtual response is present' do
    lesson = @school_class.most_recent_lesson_or_create
    question =
      lesson.questions.create!(school_class: @school_class, name: 'Question')
    @student.question_responses.create!(
      school_class: @school_class, lesson: lesson, question: nil, click: nil
    )

    assert_equal false, @student.responded_to_most_recent_question
  end
end
