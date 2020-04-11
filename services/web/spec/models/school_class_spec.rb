require 'rails_helper'

RSpec.describe SchoolClass do
  subject { create(:school_class) }
  let(:long_ago) do
    Rails.application.config.clickr.suggest_new_lesson_after_minutes.minutes
      .ago - 1.minute
  end

  describe 'suggest_creating_new_lesson' do
    it 'is false if no lesson existed' do
      expect(subject.suggest_creating_new_lesson?).to eq true
    end

    it 'is false if a new lesson exists' do
      subject.lessons.create!(name: 'lesson', created_at: 1.minute.ago)
      expect(subject.suggest_creating_new_lesson?).to eq false
    end

    it 'is true if no questions existed for an old lesson' do
      subject.lessons.create!(name: 'lesson', created_at: long_ago)
      expect(subject.suggest_creating_new_lesson?).to eq true
    end

    it 'is true if an old question existed for an old lesson' do
      lesson = subject.lessons.create!(name: 'lesson', created_at: long_ago)
      lesson.questions.create!(
        name: 'question', created_at: long_ago, school_class: subject
      )
      expect(subject.suggest_creating_new_lesson?).to eq true
    end

    it 'is false if an new question exists for an old lesson' do
      lesson = subject.lessons.create!(name: 'lesson', created_at: long_ago)
      lesson.questions.create!(
        name: 'question', created_at: 1.minute.ago, school_class: subject
      )
      expect(subject.suggest_creating_new_lesson?).to eq false
    end
  end

  describe 'update_seats' do
    it 'updates all students in transaction (swap places)' do
      s1, s2 =
        subject.students.create! [
                                   { name: '1', seat_row: 1, seat_col: 1 },
                                   { name: '4', seat_row: 2, seat_col: 2 }
                                 ]
      subject.update_seats [
                             { student_id: s1.id, seat_row: 2, seat_col: 2 },
                             { student_id: s2.id, seat_row: 1, seat_col: 1 }
                           ]
      s1.reload
      s2.reload
      expect([s1.seat_row, s1.seat_col]).to eq [2, 2]
      expect([s2.seat_row, s2.seat_col]).to eq [1, 1]
    end
  end

  describe 'clone_with_students_and_device_mappings' do
    it 'duplicates class with associations' do
      old_student =
        subject.students.create!(name: 'Max', seat_row: 1, seat_col: 1)
      old_mapping =
        old_student.student_device_mappings.create!(
          device_type: 'rfid', device_id: '1', school_class: subject
        )

      new_subject = subject.clone_with_students_and_device_mappings
      expect(new_subject.persisted?).to eq true

      expect(new_subject.students.size).to eq 1
      new_student = new_subject.students[0]
      expect(new_student.persisted?).to eq true
      expect(new_student.name).to eq 'Max'
      expect(new_student.id).not_to eq old_student.id

      expect(new_student.student_device_mappings.size).to eq 1
      new_mapping = new_student.student_device_mappings[0]
      expect(new_mapping.persisted?).to eq true
      expect(new_mapping.id).not_to eq old_mapping.id
      expect(new_mapping.school_class).to eq new_subject
    end
  end

  describe 'destroy' do
    it 'also destroys als associated records' do
      student = create(:student, school_class: subject)
      mapping =
        create(
          :student_device_mapping,
          school_class: subject,
          student: student,
          device_type: 'rfid',
          device_id: '1'
        )
      lesson = create(:lesson, school_class: subject)
      question = create(:question, school_class: subject, lesson: lesson)
      click = create(:click)
      response =
        create(
          :question_response,
          student: student,
          lesson: lesson,
          question: question,
          school_class: subject,
          click: click
        )
      response_without_question =
        create(
          :question_response,
          student: student, lesson: lesson, school_class: subject
        )

      subject.destroy

      expect(Student.exists?(student.id)).to eq false
      expect(StudentDeviceMapping.exists?(mapping.id)).to eq false
      expect(Lesson.exists?(lesson.id)).to eq false
      expect(Question.exists?(question.id)).to eq false
      expect(Click.exists?(click.id)).to eq true
      expect(QuestionResponse.exists?(response.id)).to eq false
      expect(QuestionResponse.exists?(response_without_question.id)).to eq false
    end

    it 'is allowed if class is currently selected' do
      CurrentSchoolClass.set(subject)
      subject.destroy
      expect(SchoolClass.exists?(subject.id)).to eq false
      expect(CurrentSchoolClass.get).to be_nil
    end
  end
end
