class QuestionResponse < ApplicationRecord
  strip_attributes
  belongs_to :click, optional: true
  belongs_to :student
  belongs_to :question, optional: true
  belongs_to :lesson
  belongs_to :school_class

  scope :newest_first, -> { order(created_at: :desc) }

  validates :score, presence: true
  validates :click, uniqueness: { allow_nil: true }
  validates :student, uniqueness: { scope: :question }, if: :question
  validates :school_class, inclusion: { in: ->(question_response) { [question_response.student.school_class] } }
  validates :school_class, inclusion: { in: ->(question_response) { [question_response.lesson.school_class] } }
  validates :lesson, inclusion: { in: ->(question_response) { [question_response.question.lesson] } }, if: -> { question }

  # Used to manually adjust student sum
  def is_virtual
    click.nil? && question.nil?
  end
end
