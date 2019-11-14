class Question < ApplicationRecord
  strip_attributes
  belongs_to :school_class
  belongs_to :lesson
  has_many :question_responses
  has_many :students_that_responded, through: :question_responses, class_name: 'Student'

  validates :name, presence: true, uniqueness: { scope: :lesson }
  # TODO validates lesson.school_class = school_class
end
