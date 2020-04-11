class BonusGrade < ApplicationRecord
  belongs_to :student
  belongs_to :school_class

  scope :newest_first, -> { order(created_at: :desc) }

  validates :percentage, presence: true, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 1 }
  validates :school_class,
            inclusion: { in: ->(bonus_grade) { [bonus_grade.student.school_class] } }
end
