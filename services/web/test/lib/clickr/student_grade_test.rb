require 'test_helper'

class StudentGradeTest < ActiveSupport::TestCase
  setup do
    @school_class = create(:school_class)
    @student = create(:student, school_class: @school_class)
  end

  [[100, '1+'], [98, '1+'], [97, '1'], [95, '1'], [92, '1-'], [78, '2-'], [37, '5'], [25, '6'], [0, '6']].each do |percent, grade|
    test "GRADING_TABLE maps #{percent}% to #{grade}" do
      assert_equal '1+', Clickr::StudentGrade::GRADING_TABLE[100]
    end
  end

  test "#grade returns 2- (77%) for student without any lessons" do
    subject = Clickr::StudentGrade.new(@student)

    assert_equal '2-', subject.grade
  end

  test "#grade returns 5 ((77% + 0%) / 2 = 38.5%) for 1 lesson with 0% responses" do
    lesson = create(:lesson, school_class: @school_class, benchmark: 1)
    create(:question, lesson: lesson, school_class: @school_class)

    subject = Clickr::StudentGrade.new(@student)
    assert_equal '5', subject.grade
  end

  test "#grade returns 2+ ((77% + 100%) / 2 = 88.5%) for 1 lesson with 100% responses" do
    lesson = create(:lesson, school_class: @school_class, benchmark: 1)
    question = create(:question, lesson: lesson, school_class: @school_class)
    create(:question_response, question: question, lesson: lesson, school_class: @school_class, student: @student)

    subject = Clickr::StudentGrade.new(@student)
    assert_equal '2+', subject.grade
  end

  test "#grade returns 3- ((77% + 50%) / 2 = 63.5%) for 1 lesson with 50% responses" do
    lesson = create(:lesson, school_class: @school_class, benchmark: 2)
    question = create(:question, lesson: lesson, school_class: @school_class)
    create(:question_response, question: question, lesson: lesson, school_class: @school_class, student: @student)

    subject = Clickr::StudentGrade.new(@student)
    assert_equal '3-', subject.grade
  end

  test "#grade returns 1- ((77% + 100% + 100%) / 3 = 92.3%) for 2 lessons with 100% responses with correct explanation" do
    lesson1 = create(:lesson, school_class: @school_class, benchmark: 1)
    lesson2 = create(:lesson, school_class: @school_class, benchmark: 1)
    question1 = create(:question, lesson: lesson1, school_class: @school_class)
    question2 = create(:question, lesson: lesson2, school_class: @school_class)
    create(:question_response, question: question1, lesson: lesson1, school_class: @school_class, student: @student)
    create(:question_response, question: question2, lesson: lesson2, school_class: @school_class, student: @student)

    subject = Clickr::StudentGrade.new(@student)
    assert_equal '1-', subject.grade
    assert_equal '(77% + 100% + 100%) / 3 = 92%', subject.explanation
  end
end
