class StudentDeviceMapping < ApplicationRecord
  strip_attributes
  belongs_to :student
  belongs_to :school_class

  validates :device_type, presence: true
  validates :device_id, presence: true, uniqueness: { scope: :school_class }
  # TODO validates student.school_class = school_class
end
