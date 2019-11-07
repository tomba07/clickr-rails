class Question < ApplicationRecord
  strip_attributes
  belongs_to :school_class
  belongs_to :lesson
end
