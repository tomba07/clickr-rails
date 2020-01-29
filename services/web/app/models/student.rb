class Student < ApplicationRecord
  strip_attributes
  belongs_to :school_class
  has_many :question_responses, dependent: :destroy
  has_many :questions_that_he_responded_to,
           through: :question_responses, class_name: 'Question'
  has_many :student_device_mappings,
           dependent: :destroy

  scope :newest_first, ->() { order(created_at: :desc) }

  validates :name, presence: true, uniqueness: { scope: :school_class }
  validates :seat_row,
            presence: true,
            numericality: { only_integer: true },
            uniqueness: { scope: %i[school_class seat_col] }
  validates :seat_col,
            presence: true,
            numericality: { only_integer: true },
            uniqueness: { scope: %i[school_class seat_row] }

  def question_response_sum
    question_responses.sum(:score)
  end

  def question_response_sum_for_most_recent_lesson
    lesson = school_class.most_recent_lesson or return 0
    question_responses.where(lesson: lesson).sum(:score)
  end

  def nth_incomplete_mapping
    student_device_mappings.incomplete.first&.nth_incomplete
  end

  def responded_to_most_recent_question
    question_responses.for_most_recent_question(school_class).exists?
  end
end
