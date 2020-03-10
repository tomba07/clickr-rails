class Lesson < ApplicationRecord
  strip_attributes
  belongs_to :school_class
  has_many :questions, dependent: :destroy
  has_many :question_responses, dependent: :destroy

  scope :newest_first, -> { order(created_at: :desc) }
  scope :with_participation_of,
        lambda { |student:|
          joins(:question_responses).where(
            question_responses: { student: student }
          )
            .distinct
        }

  validates :name, presence: true, uniqueness: { scope: :school_class }
  validates :benchmark,
            presence: true,
            numericality: { only_integer: true, greater_than: 0 }

  def most_recent_question
    questions.last
  end
end
