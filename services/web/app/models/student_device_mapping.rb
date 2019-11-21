class StudentDeviceMapping < ApplicationRecord
  include DeviceIdPrefixer

  strip_attributes
  belongs_to :student
  belongs_to :school_class

  validates :device_id, uniqueness: { scope: :school_class }
  # TODO validates student.school_class = school_class

  before_validation :set_incomplete!

  # Can't be a scope, as it returns only a single record
  def self.oldest_incomplete
    where(incomplete: true).first
  end

  private
  def set_incomplete!
    self.incomplete = device_id.blank? || device_type.blank?
  end
end
