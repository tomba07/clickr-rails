require 'rails_helper'

RSpec.describe Student do
  let(:school_class) { create(:school_class) }
  let(:student) { create(:student, school_class: school_class) }

  describe 'question_response_sum' do
    it 'sums up all scores' do
      student.question_responses <<
        (1..5).to_a.map { create(:question_response, school_class: school_class) }

      expect(student.question_response_sum).to eq 5
    end
  end

  describe 'question_response_sum_for_most_recent_lesson' do
    it 'sums up all scores only for questions in most recent lesson' do
      old_lesson, most_recent_lesson = create_list(:lesson, 2, school_class: school_class)
      create_list(:question_response, 3, student: student, school_class: school_class, lesson: old_lesson)
      create_list(:question_response, 5, student: student, school_class: school_class, lesson: most_recent_lesson)

      expect(student.question_response_sum_for_most_recent_lesson).to eq 5
    end
  end

  describe 'nth_incomplete_mapping' do
    it 'selects oldest incomplete mapping' do
      CurrentSchoolClass.set school_class
      student.student_device_mappings.create!(school_class: school_class)
      student.student_device_mappings.create!(school_class: school_class)

      other_student = create(:student, school_class: school_class)
      other_student.student_device_mappings.create!(school_class: school_class)

      expect(student.nth_incomplete_mapping).to eq 0
      expect(other_student.nth_incomplete_mapping).to eq 2
    end

    it 'returns nil if no incomplete mapping exists' do
      student.student_device_mappings.create!(
        school_class: school_class, device_type: 'rfid', device_id: '1'
      )

      assert_nil student.nth_incomplete_mapping
    end
  end

  describe 'responded_to_most_recent_question' do
    it 'returns true if student responded' do
      lesson = school_class.most_recent_lesson_or_create
      question =
        lesson.questions.create!(school_class: school_class, name: 'Question')
      click = create(:click)
      student.question_responses.create!(
        school_class: school_class,
        lesson: lesson,
        question: question,
        click: click
      )

      expect(student.responded_to_most_recent_question).to eq true
    end

    it 'returns false if student did not respond' do
      lesson = school_class.most_recent_lesson_or_create
      question =
        lesson.questions.create!(school_class: school_class, name: 'Question')

      expect(student.responded_to_most_recent_question).to eq false
    end

    it 'returns false if only a virtual response is present' do
      lesson = school_class.most_recent_lesson_or_create
      question =
        lesson.questions.create!(school_class: school_class, name: 'Question')
      student.question_responses.create!(
        school_class: school_class, lesson: lesson, question: nil, click: nil
      )

      expect(student.responded_to_most_recent_question).to eq false
    end
  end

  describe 'destroy' do
    it 'deletes dependent objects' do
      lesson = Lesson.create!(school_class: school_class, name: 'Lesson')
      question =
        Question.create!(
          school_class: school_class, lesson: lesson, name: 'Question'
        )
      question_response =
        QuestionResponse.create!(
          question: question,
          student: student,
          lesson: lesson,
          school_class: school_class
        )
      mapping =
        StudentDeviceMapping.create!(
          student: student,
          device_type: 'rfid',
          device_id: '1',
          school_class: school_class
        )

      student.destroy!

      expect(QuestionResponse.exists?(question_response.id)).to eq false
      expect(StudentDeviceMapping.exists?(mapping.id)).to eq false
    end
  end

  describe 'that_participated_in' do
    it 'returns only students with score above threshold' do
      student_with_score_2 = student
      student_with_score_0 = create(:student, school_class: school_class)
      student_with_score_minus_1 = create(:student, school_class: school_class)
      lesson = create(:lesson, school_class: school_class)
      create_list(
        :question_response,
        2,
        lesson: lesson,
        school_class: school_class,
        student: student_with_score_2
      )
      create(
        :question_response,
        score: -1,
        lesson: lesson,
        school_class: school_class,
        student: student_with_score_minus_1
      )

      expect(Student.that_participated_in(lesson: lesson)).to eq [
           student_with_score_2,
           student_with_score_0
         ]
    end
  end
end
