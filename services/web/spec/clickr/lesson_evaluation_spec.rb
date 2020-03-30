require 'rails_helper'

RSpec.describe Clickr::LessonEvaluation do
  let!(:school_class) { create(:school_class) }
  let!(:students) { create_list(:student, 3, school_class: school_class) }
  let!(:lesson) { create(:lesson, school_class: school_class) }
  let!(:question) do
    create(:question, school_class: school_class, lesson: lesson)
  end
  let!(:responses) do
    [1, -1, -1].each_with_index do |score, i|
      create(
        :question_response,
        student: students[i], question: question, lesson: lesson, score: score, school_class: school_class
      )
    end
  end
  subject { Clickr::LessonEvaluation.new(lesson) }

  describe 'max_question_response_sum' do
    it 'is 1' do
      expect(subject.max_question_response_sum).to eq 1
    end
  end

  describe 'min_question_response_sum' do
    it 'is 0 (the lowest count above the participation threshold)' do
      create(:question_response, student: students[1], lesson: lesson, school_class: school_class)
      expect(subject.min_question_response_sum).to eq 0
    end
  end

  describe 'nth_highest_question_response_sum' do
    it 'is 1 for highest (n=1)' do
      expect(subject.nth_highest_question_response_sum(n: 1)).to eq 1
    end

    it 'is 1 if N exceeds student count' do
      expect(
        subject.nth_highest_question_response_sum(n: students.size + 1)
      ).to eq 1
    end
  end

  describe 'average_percentage' do
    it 'is 100% (ignores absent students)' do
      expect(subject.average_percentage).to eq 1.0
    end

    it 'is 75% ((2 + 1) / 2) (ignores absent students)' do
      other_student = create(:student, school_class: school_class)
      create(:question_response, student: students[0], lesson: lesson, school_class: school_class)
      create(:question_response, student: other_student, lesson: lesson, school_class: school_class)

      lesson.update!(benchmark: 2)

      expect(subject.average_percentage).to eq 0.75
    end
  end
end
