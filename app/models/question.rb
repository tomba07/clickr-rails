class Question < ApplicationRecord
  strip_attributes
  belongs_to :school_class
end
