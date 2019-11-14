class QuestionResponse < ApplicationRecord
  strip_attributes
  belongs_to :click
  belongs_to :student
  belongs_to :question
  belongs_to :lesson
  belongs_to :school_class

  validates :score, presence: true
  validates :click, uniqueness: true
  # TODO validates student.school_class = school_class
  # TODO validates lesson.school_class = school_class
  # TODO validates question.lesson = lesson
end
