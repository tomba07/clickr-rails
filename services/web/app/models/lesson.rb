class Lesson < ApplicationRecord
  strip_attributes
  belongs_to :school_class
  has_many :questions
  has_many :question_responses

  scope :newest_first, ->() { order(created_at: :desc) }

  validates :name, presence: true, uniqueness: { scope: :school_class }

  def most_recent_question
    questions.last
  end
end
