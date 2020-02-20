class CurrentSchoolClass < ApplicationRecord
  belongs_to :school_class

  def self.set(school_class)
    singleton_entry = first_or_create
    singleton_entry.school_class = school_class
    singleton_entry.save!
  end

  def self.get
    first&.school_class
  end
end
