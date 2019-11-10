class Student < ApplicationRecord
  strip_attributes
  belongs_to :school_class

  def seat_hash
    ApplicationController.helpers.seat_hash(seat_row, seat_col)
  end
end
