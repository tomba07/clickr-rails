require 'rails_helper'

RSpec.describe Lesson do
  let(:school_class) { create(:school_class) }
  let(:student) { create(:student, school_class: school_class) }

  describe 'with_participation_of' do
    it 'returns only lessons with score above threshold' do
      lesson_with_score_1, lesson_with_score_0, lesson_with_score_minus_1 =
        create_list(:lesson, 3, school_class: school_class)
      create(
        :question_response,
        lesson: lesson_with_score_1,
        school_class: school_class,
        student: student
      )
      create(
        :question_response,
        lesson: lesson_with_score_minus_1,
        score: -1,
        school_class: school_class,
        student: student
      )

      expect(Lesson.with_participation_of(student: student)).to eq [
           lesson_with_score_1,
           lesson_with_score_0
         ]
    end
  end
end
