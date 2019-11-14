class Lesson < ApplicationRecord
  strip_attributes
  belongs_to :school_class
  has_many :questions
  has_one :question_responses

  validates :name, presence: true, uniqueness: { scope: :school_class }

  def most_recent_question
    questions.last
  end
end
