class Lesson < ApplicationRecord
  strip_attributes
  belongs_to :school_class
  has_many :questions
end
