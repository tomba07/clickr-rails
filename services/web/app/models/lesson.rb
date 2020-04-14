class Lesson < ApplicationRecord
  strip_attributes
  belongs_to :school_class
  has_many :questions, dependent: :destroy
  has_many :question_responses, dependent: :destroy

  scope :newest_first, -> { order(created_at: :desc) }
  scope :with_participation_of,
        lambda { |student:|
          threshold =
            Rails.application.config.clickr
              .student_absent_if_lesson_sum_less_than_or_equal_to
          # TODO Performance: group by having SUM() >
          where(school_class: student.school_class).select { |l|
            student.question_response_sum_for(lesson: l) > threshold
          }
        }

  validates :name, presence: true, uniqueness: { scope: :school_class }
  validates :benchmark, presence: true, numericality: { greater_than: 0 }

  def most_recent_question
    questions.last
  end

  def benchmark
    self[:benchmark] || 1.0
  end

  def has_benchmark
    self[:benchmark].present?
  end

  def question_score_sum
    questions.sum(:score)
  end
end
