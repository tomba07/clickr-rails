class SchoolClass < ApplicationRecord
  strip_attributes
  has_many :students
  has_many :lessons
  has_many :questions

  def most_recent_lesson_or_create
    lessons.last || lessons.create!(title: "Lesson 1 (#{name})")
  end

  def suggest_creating_new_lesson?
    lesson = most_recent_lesson_or_create
    question = lesson.most_recent_question

    latest_timestamp = question&.created_at || lesson&.created_at
    comparison_timestamp = Rails.application.config.clickr.suggest_new_lesson_after_minutes.minutes.ago

    latest_timestamp < comparison_timestamp
  end

  def floor_plan
    config = Rails.application.config.clickr
    rows = [*students.map { |s| s.seat_row }, config.min_seat_rows - 1].max + 1
    cols = [*students.map { |s| s.seat_col }, config.min_seat_cols - 1].max + 1
    # Can't use double splat operator { **tmp, s.seat_hash => s } with non-symbol (object) keys
    hash = students.reduce({}) { |tmp, s| tmp.merge({ s.seat_hash => s }) }
    Array.new(rows) { |row| Array.new(cols) { |col| hash[ApplicationController.helpers.seat_hash(row, col)] } }
  end
end