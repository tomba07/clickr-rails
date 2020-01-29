class Lesson < ApplicationRecord
  strip_attributes
  belongs_to :school_class
  has_many :questions, dependent: :destroy
  has_many :question_responses, dependent: :destroy

  scope :newest_first, -> { order(created_at: :desc) }

  validates :name, presence: true, uniqueness: { scope: :school_class }

  def most_recent_question
    questions.last
  end
end
