class StudentDeviceMapping < ApplicationRecord
  include DeviceIdPrefixer

  strip_attributes
  belongs_to :student
  belongs_to :school_class

  scope :newest_first, -> { order(created_at: :desc) }

  validates :device_id, uniqueness: { scope: :school_class, allow_nil: true }
  # TODO validates student.school_class = school_class

  before_validation :set_incomplete!

  scope :incomplete, -> { where(incomplete: true) }

  # Can't be a scope, as it returns only a single record
  def self.oldest_incomplete(device_id, school_class = CurrentSchoolClass.get)
    return nil if !school_class
    return nil if school_class.has_mapping_for(device_id)

    incomplete.where(school_class: school_class).first
  end

  def nth_incomplete(school_class = CurrentSchoolClass.get)
    return nil if !school_class
    incomplete = school_class.student_device_mappings.incomplete
    return nil if !incomplete
    incomplete.pluck(:id).index(id)
  end

  private

  def set_incomplete!
    self.incomplete = device_id.blank? || device_type.blank?
  end
end
