class SchoolClass < ApplicationRecord
  strip_attributes
  has_many :bonus_grades, dependent: :destroy
  has_many :lessons, dependent: :destroy
  has_many :questions, dependent: :destroy
  has_many :question_responses, dependent: :destroy
  has_many :student_device_mappings, dependent: :destroy
  has_many :students, dependent: :destroy
  has_one :current_school_class, dependent: :destroy

  scope :newest_first, -> { order(created_at: :desc) }

  validates :name, presence: true, uniqueness: true

  def most_recent_lesson
    lessons.last
  end

  def most_recent_lesson_or_create
    most_recent_lesson ||
      lessons.create!(
        name: I18n.t('lessons.create.default_name', school_class_name: name)
      )
  end

  def has_mapping_for(device_id)
    student_device_mappings.where(device_id: device_id).exists?
  end

  # TODO Extract into task
  def suggest_creating_new_lesson?
    lesson = most_recent_lesson or return true

    question = lesson.most_recent_question

    latest_timestamp = question&.created_at || lesson&.created_at
    comparison_timestamp =
      Rails.application.config.clickr.suggest_new_lesson_after_minutes.minutes
        .ago

    latest_timestamp < comparison_timestamp
  end

  def most_recent_question
    most_recent_lesson&.most_recent_question
  end

  def update_seats(seats)
    # TODO exception handling
    transaction { seats.each(&(method :update_seat)) }
  end

  def update_seat(student_id:, seat_row:, seat_col:)
    student = students.find(student_id)
    # Bypass validation (when swapping seats, one seat is briefly occupied twice)
    student.attributes = { seat_row: seat_row, seat_col: seat_col }
    student.save! validate: false
  end

  # TODO Extract into task
  def clone_with_students_and_device_mappings(
    new_name: I18n.t('school_classes.cloned_name', name: name)
  )
    new_school_class = self.dup
    new_school_class.name = new_name
    new_school_class.save!

    self.students.includes(:student_device_mappings).each do |student|
      new_student = student.dup
      new_student.school_class = new_school_class
      new_student.save!

      student.student_device_mappings.each do |mapping|
        new_mapping = mapping.dup
        new_mapping.school_class = new_school_class
        new_mapping.student = new_student
        new_mapping.save!
      end
    end

    new_school_class
  end
end
