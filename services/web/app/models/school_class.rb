class SchoolClass < ApplicationRecord
  strip_attributes
  has_many :students
  has_many :lessons
  has_many :questions
  has_many :question_responses

  validates :name, presence: true, uniqueness: true

  def most_recent_lesson_or_create
    lessons.last || lessons.create!(name: I18n.t('lesson.create.default_name', school_class_name: name))
  end

  def suggest_creating_new_lesson?
    lesson = most_recent_lesson_or_create
    question = lesson.most_recent_question

    latest_timestamp = question&.created_at || lesson&.created_at
    comparison_timestamp = Rails.application.config.clickr.suggest_new_lesson_after_minutes.minutes.ago

    latest_timestamp < comparison_timestamp
  end

  def unoccupied_seats
    number_of_rows = students.map { |s| s.seat_row }.max
    number_of_cols = students.map { |s| s.seat_col }.max
    # Add one extra row and column as drag and drop targets
    all_seats = (1..number_of_rows + 1).to_a.product((1..number_of_cols + 1).to_a)
    occupied_seats = students.map{ |s| [s.seat_row, s.seat_col] }
    return all_seats - occupied_seats
  end
end
