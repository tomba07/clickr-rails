class Clickr::StudentGrade
  attr_reader :grade, :explanation, :percentage

  def initialize(student)
    lessons = student.school_class.lessons
    lessons_with_participation = lessons.with_participation_of student: student
    bonus_grades = student.bonus_grades

    initial_percentage =
      Rails.application.config.clickr.initial_student_response_percentage
    lesson_percentages =
      lessons_with_participation.map do |l|
        student.question_response_percentage_for lesson: l
      end
    bonus_percentages = bonus_grades.map(&:percentage)
    percentage_groups = [
      [initial_percentage],
      lesson_percentages,
      bonus_percentages
    ]
    percentages = percentage_groups.flatten
    @percentage = percentages.sum / percentages.size

    @grade = Clickr::Grade.from_percentage(@percentage)
    @explanation =
      "(#{percentage_groups.map { |g| group_to_s g }.compact.join(' + ')}) / #{
        percentages.size
      } = #{percentage_to_s @percentage}"
  end

  private

  def percentage_to_s(percentage)
    ActiveSupport::NumberHelper.number_to_percentage(
      100.0 * percentage,
      precision: 0
    )
  end

  def group_to_s(percentages)
    return nil if percentages.empty?
    return percentage_to_s(percentages[0]) if percentages.size == 1

    "(#{percentages.map { |p| percentage_to_s p }.join(' + ')})"
  end
end
