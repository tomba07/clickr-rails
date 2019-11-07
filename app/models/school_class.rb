class SchoolClass < ApplicationRecord
  strip_attributes
  has_many :students
  has_many :lessons
  has_many :questions

  def most_recent_lesson
    lessons.last
  end
end
