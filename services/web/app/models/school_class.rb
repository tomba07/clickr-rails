class SchoolClass < ApplicationRecord
  strip_attributes
  has_many :students
  has_many :lessons
  has_many :questions
  has_many :question_responses

  validates :name, presence: true, uniqueness: true

  def most_recent_lesson
    lessons.last
  end

  def most_recent_lesson_or_create
    most_recent_lesson || lessons.create!(name: I18n.t('lessons.create.default_name', school_class_name: name))
  end

  def suggest_creating_new_lesson?
    lesson = most_recent_lesson or return true

    question = lesson.most_recent_question

    latest_timestamp = question&.created_at || lesson&.created_at
    comparison_timestamp = Rails.application.config.clickr.suggest_new_lesson_after_minutes.minutes.ago

    latest_timestamp < comparison_timestamp
  end

  def most_recent_question
    most_recent_lesson&.most_recent_question
  end

  def update_seats(seats)
    # TODO exception handling
    transaction do
      seats.each(&(method :update_seat))
    end
  end

  def update_seat(student_id:, seat_row:, seat_col:)
    student = students.find(student_id)
    # Bypass validation (when swapping seats, one seat is briefly occupied twice)
    student.attributes = { seat_row: seat_row, seat_col: seat_col }
    student.save! validate: false
  end
end
