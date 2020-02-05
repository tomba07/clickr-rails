class Clickr::StudentGrade
  attr_reader :grade, :explanation

  GRADING_TABLE = [
    [98..100, '1+'], # [98, 100] => 98 and 100 inclusive
    [95...98, '1'], # [95, 98) => 95 inclusive, 98 exclusive
    [92...95, '1-'],
    [87...92, '2+'],
    [82...87, '2'],
    [77...82, '2-'],
    [72...77, '3+'],
    [68...72, '3'],
    [62...68, '3-'],
    [57...62, '4+'],
    [52...57, '4'],
    [47...52, '4-'],
    [42...47, '5+'],
    [37...42, '5'],
    [25...37, '5-'],
    [0...25, '6'],
  ].flat_map { |range, grade| range.to_a.map { |p| [p, grade] } }.to_h.freeze

  def initialize(student)
    lessons = student.school_class.lessons

    initial_percentage = Rails.application.config.clickr.initial_student_response_percentage
    lesson_percentages = lessons.map { |l| student.question_response_percentage_for lesson: l }
    percentages = [initial_percentage, *lesson_percentages]
    average_percentage = percentages.sum / percentages.size

    @grade = GRADING_TABLE[(100.0 * average_percentage).floor]
    @explanation = "(#{percentages.map { |p| to_s p }.join(' + ')}) / #{percentages.size} = #{to_s average_percentage}"
  end

  private

  def to_s(percentage)
    "#{(100.0 * percentage).floor}%"
  end
end
