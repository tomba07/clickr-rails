require 'rails_helper'

RSpec.describe Clickr::StudentGrade do
  let(:school_class) { create(:school_class) }
  let(:student) { create(:student, school_class: school_class) }
  subject { Clickr::StudentGrade.new(student) }

  describe 'grade' do
    it 'returns 2- (77%) for student without any lessons' do
      subject = Clickr::StudentGrade.new(student)

      expect(subject.grade).to eq '2-'
      expect(subject.percentage).to eq 0.77
    end

    it 'returns 2- (77%) for 1 lesson with with score -1 (student is considered absent)' do
      lesson = create(:lesson, school_class: school_class, benchmark: 1)
      create(:question, lesson: lesson, school_class: school_class)
      create(
        :question_response,
        score: -1, lesson: lesson, school_class: school_class, student: student
      )

      expect(subject.grade).to eq '2-'
      expect(subject.percentage).to eq 0.77
    end

    it 'returns 5 ((77% + 0%) / 2 = 38.5%) for 1 lesson with with score 0 (student is NOT considered absent)' do
      lesson = create(:lesson, school_class: school_class, benchmark: 1)
      create(:question, lesson: lesson, school_class: school_class)

      expect(subject.grade).to eq '5'
      expect(subject.percentage).to eq 0.385
    end

    it 'returns 2+ ((77% + 100%) / 2 = 88.5%) for 1 lesson with 100% responses' do
      lesson = create(:lesson, school_class: school_class, benchmark: 1)
      question = create(:question, lesson: lesson, school_class: school_class)
      create(
        :question_response,
        question: question,
        lesson: lesson,
        school_class: school_class,
        student: student
      )

      expect(subject.grade).to eq '2+'
      expect(subject.percentage).to eq 0.885
    end

    it 'returns 3- ((77% + 50%) / 2 = 63.5%) for 1 lesson with 50% responses' do
      lesson = create(:lesson, school_class: school_class, benchmark: 2)
      question = create(:question, lesson: lesson, school_class: school_class)
      create(
        :question_response,
        question: question,
        lesson: lesson,
        school_class: school_class,
        student: student
      )

      expect(subject.grade).to eq '3-'
      expect(subject.percentage).to eq 0.635
    end

    it 'returns 1- ((77% + 100% + 100%) / 3 = 92.3%) for 2 lessons with 100% responses with correct explanation' do
      lesson1 = create(:lesson, school_class: school_class, benchmark: 1)
      lesson2 = create(:lesson, school_class: school_class, benchmark: 1)
      question1 = create(:question, lesson: lesson1, school_class: school_class)
      question2 = create(:question, lesson: lesson2, school_class: school_class)
      create(
        :question_response,
        question: question1,
        lesson: lesson1,
        school_class: school_class,
        student: student
      )
      create(
        :question_response,
        question: question2,
        lesson: lesson2,
        school_class: school_class,
        student: student
      )

      expect(subject.grade).to eq '1-'
      expect(subject.explanation).to eq '(77% + 100% + 100%) / 3 = 92%'
    end
  end

  describe 'explanation' do
    it 'does not contain lessons in which student was absent' do
      lesson = create(:lesson, school_class: school_class, benchmark: 1)
      create(:question, lesson: lesson, school_class: school_class)
      create(
        :question_response,
        score: -1, lesson: lesson, school_class: school_class, student: student
      )

      expect(subject.explanation).to eq '(77%) / 1 = 77%'
    end
  end
end
