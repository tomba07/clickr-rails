require 'test_helper'

class SchoolClassTest < ActiveSupport::TestCase
  def setup
    @subject = create(:school_class)
    @long_ago =
      Rails.application.config.clickr.suggest_new_lesson_after_minutes.minutes
        .ago -
        1.minute
  end

  test 'suggest_creating_new_lesson is false if no lesson existed' do
    assert_equal true, @subject.suggest_creating_new_lesson?
  end

  test 'suggest_creating_new_lesson is false if a new lesson exists' do
    @subject.lessons.create!(name: 'lesson', created_at: 1.minute.ago)
    assert_equal false, @subject.suggest_creating_new_lesson?
  end

  test 'suggest_creating_new_lesson is true if no questions existed for an old lesson' do
    @subject.lessons.create!(name: 'lesson', created_at: @long_ago)
    assert_equal true, @subject.suggest_creating_new_lesson?
  end

  test 'suggest_creating_new_lesson is true if an old question existed for an old lesson' do
    lesson = @subject.lessons.create!(name: 'lesson', created_at: @long_ago)
    lesson.questions.create!(
      name: 'question', created_at: @long_ago, school_class: @subject
    )
    assert_equal true, @subject.suggest_creating_new_lesson?
  end

  test 'suggest_creating_new_lesson is false if an new question exists for an old lesson' do
    lesson = @subject.lessons.create!(name: 'lesson', created_at: @long_ago)
    lesson.questions.create!(
      name: 'question', created_at: 1.minute.ago, school_class: @subject
    )
    assert_equal false, @subject.suggest_creating_new_lesson?
  end

  test 'seating_plan= updates all students in transaction (swap places)' do
    s1, s2 =
      @subject.students.create! [
                                  { name: '1', seat_row: 1, seat_col: 1 },
                                  { name: '4', seat_row: 2, seat_col: 2 }
                                ]
    @subject.update_seats [
                            { student_id: s1.id, seat_row: 2, seat_col: 2 },
                            { student_id: s2.id, seat_row: 1, seat_col: 1 }
                          ]
    s1.reload
    s2.reload
    assert_equal [2, 2], [s1.seat_row, s1.seat_col]
    assert_equal [1, 1], [s2.seat_row, s2.seat_col]
  end

  test 'clone_with_students_and_device_mappings duplicates class with associations' do
    old_student = @subject.students.create!(name: 'Max', seat_row: 1, seat_col: 1)
    old_mapping = old_student.student_device_mappings.create!(device_type: 'rfid', device_id: '1', school_class: @subject)

    new_subject = @subject.clone_with_students_and_device_mappings
    assert_equal true, new_subject.persisted?

    assert_equal 1, new_subject.students.size
    new_student = new_subject.students[0]
    assert_equal true, new_student.persisted?
    assert_equal 'Max', new_student.name
    assert_not_equal old_student.id, new_student.id

    assert_equal 1, new_student.student_device_mappings.size
    new_mapping = new_student.student_device_mappings[0]
    assert_equal true, new_mapping.persisted?
    assert_not_equal old_mapping.id, new_mapping.id
    assert_equal new_subject, new_mapping.school_class
  end

  test 'destroy also destroys als associated records' do
    student = create(:student, school_class: @subject)
    mapping = create(:student_device_mapping, school_class: @subject, student: student, device_type: 'rfid', device_id: '1')
    lesson = create(:lesson, school_class: @subject)
    question = create(:question, school_class: @subject, lesson: lesson)
    click = create(:click)
    response = create(:question_response, student: student, lesson: lesson, question: question, school_class: @subject, click: click)
    response_without_question = create(:question_response, student: student, lesson: lesson, school_class: @subject)

    @subject.destroy

    assert_equal false, Student.exists?(student.id)
    assert_equal false, StudentDeviceMapping.exists?(mapping.id)
    assert_equal false, Lesson.exists?(lesson.id)
    assert_equal false, Question.exists?(question.id)
    assert_equal true, Click.exists?(click.id)
    assert_equal false, QuestionResponse.exists?(response.id)
    assert_equal false, QuestionResponse.exists?(response_without_question.id)
  end
end
