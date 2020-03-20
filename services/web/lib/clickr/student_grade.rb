class Clickr::StudentGrade
  attr_reader :grade, :explanation, :percentage

  def initialize(student)
    lessons = student.school_class.lessons
    lessons_with_participation = lessons.with_participation_of student: student

    initial_percentage =
      Rails.application.config.clickr.initial_student_response_percentage
    lesson_percentages =
      lessons_with_participation.map do |l|
        student.question_response_percentage_for lesson: l
      end
    percentages = [initial_percentage, *lesson_percentages]
    @percentage = percentages.sum / percentages.size

    @grade = Clickr::Grade.from_percentage(@percentage)
    @explanation =
      "(#{percentages.map { |p| to_s p }.join(' + ')}) / #{
        percentages.size
      } = #{to_s @percentage}"
  end

  private

  def to_s(percentage)
    ActiveSupport::NumberHelper.number_to_percentage(100.0 * percentage, precision: 0)
  end
end
