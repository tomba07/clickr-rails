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
    most_recent_lesson || lessons.create!(name: I18n.t('lesson.create.default_name', school_class_name: name))
  end

  def suggest_creating_new_lesson?
    lesson = most_recent_lesson or return true

    question = lesson.most_recent_question

    latest_timestamp = question&.created_at || lesson&.created_at
    comparison_timestamp = Rails.application.config.clickr.suggest_new_lesson_after_minutes.minutes.ago

    latest_timestamp < comparison_timestamp
  end

  def seating_plan
    return [] if !students.exists?

    row_min, row_max = students.map { |s| s.seat_row }.minmax
    col_min, col_max = students.map { |s| s.seat_col }.minmax
    row_offset = row_min - 2
    col_offset = col_min - 2
    # Can't use double splat operator { **tmp, s.seat_hash => s } with non-symbol (object) keys
    students_index = students.reduce({}) { |tmp, s| tmp.merge({seat_hash(s.seat_row, s.seat_col) => s}) }
    seat_coordinates = (row_min - 1..row_max + 1).to_a.product((col_min - 1..col_max + 1).to_a)
    seats = seat_coordinates.map do |row, col|
      {
        row: row - row_offset,
        col: col - col_offset,
        is_empty: !students_index.has_key?(seat_hash(row, col)),
        student: students_index[seat_hash(row, col)],
        is_border: row < row_min || row > row_max || col < col_min || col > col_max,
      }
    end

    return { seats: seats, row_offset: row_offset, col_offset: col_offset}
  end

  def seating_plan=(seats)
    # TODO exception handling
    transaction do
      seats.each(&(method :update_seat))
    end
  end

  private

  def seat_hash(row, col)
    {row: row, col: col}.freeze
  end

  def update_seat(student_id:, row:, col:)
    student = students.find(student_id)
    # Bypass validation (when swapping seats, one seat is briefly occupied twice)
    student.attributes = { seat_row: row, seat_col: col }
    student.save! validate: false
  end
end
