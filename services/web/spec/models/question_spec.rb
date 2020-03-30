require 'rails_helper'

RSpec.describe Question do
  describe 'default_name' do
    it 'uses count for first question' do
      school_class = create(:school_class)
      lesson = school_class.lessons.create!(name: 'L1')

      expect(Question.default_name(lesson)).to eq 'Question 1'
    end

    it 'uses count for second question' do
      school_class = create(:school_class)
      lesson = school_class.lessons.create!(name: 'L1')
      lesson.questions.create!(school_class: school_class, name: 'Q1')

      expect(Question.default_name(lesson)).to eq 'Question 2'
    end
  end
end
