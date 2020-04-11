class Student < ApplicationRecord
  strip_attributes
  belongs_to :school_class
  has_many :bonus_grades, dependent: :destroy
  has_many :question_responses, dependent: :destroy
  has_many :questions_that_he_responded_to,
           through: :question_responses, class_name: 'Question'
  has_many :student_device_mappings, dependent: :destroy

  scope :newest_first, -> { order(created_at: :desc) }
  scope :that_participated_in,
        lambda { |lesson:|
          threshold =
            Rails.application.config.clickr
              .student_absent_if_lesson_sum_less_than_or_equal_to
          # TODO Performance: group by having SUM() >
          where(school_class: lesson.school_class).select { |s|
            s.question_response_sum_for(lesson: lesson) > threshold
          }
        }

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
    question_response_sum_for lesson: school_class.most_recent_lesson or
      return 0
  end

  def question_response_sum_for(lesson:)
    question_responses.where(lesson: lesson).sum(:score)
  end

  def question_response_percentage_for(lesson:)
    # TODO Weighted percentage of geometric and linear progression (customize via formula)
    percentage =
      question_response_sum_for(lesson: lesson).to_f / lesson.benchmark
    [1.0, percentage].min
  end

  def nth_incomplete_mapping
    student_device_mappings.incomplete.first&.nth_incomplete
  end

  def responded_to_most_recent_question
    most_recent_question = school_class.most_recent_question
    return false if !most_recent_question

    question_responses.where(question: most_recent_question).exists?
  end
end
