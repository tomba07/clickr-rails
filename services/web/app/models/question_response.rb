class QuestionResponse < ApplicationRecord
  strip_attributes
  belongs_to :click, optional: true
  belongs_to :student
  belongs_to :question, optional: true
  belongs_to :lesson
  belongs_to :school_class

  scope :newest_first, ->() { order(created_at: :desc) }

  validates :score, presence: true
  validates :click, uniqueness: { allow_nil: true }
  validates :student, uniqueness: { scope: :question }, if: :question
  # TODO validates student.school_class = school_class
  # TODO validates lesson.school_class = school_class
  # TODO validates question.lesson = lesson

  scope :for_most_recent_question,
        ->(school_class) { where(question: school_class.most_recent_question) }

  # Used to manually adjust student sum
  def is_virtual
    click.nil? && question.nil?
  end
end
