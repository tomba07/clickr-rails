class QuestionResponse < ApplicationRecord
  strip_attributes
  belongs_to :click
  belongs_to :student
  belongs_to :question
  belongs_to :lesson
  belongs_to :school_class

  validates :score, presence: true
end
