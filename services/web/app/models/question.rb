class Question < ApplicationRecord
  strip_attributes
  belongs_to :school_class
  belongs_to :lesson
  has_many :question_responses
  has_many :students_that_responded, through: :question_responses, class_name: 'Student'

  validates :text, presence: true, uniqueness: { scope: :lesson }
end
