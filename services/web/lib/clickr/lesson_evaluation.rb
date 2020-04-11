class Clickr::LessonEvaluation
  attr_reader :min_question_response_sum,
              :max_question_response_sum,
              :average_percentage

  def initialize(lesson)
    school_class = lesson.school_class
    students = school_class.students.includes(:bonus_grades)

    students_that_participated = students.that_participated_in lesson: lesson

    @sums =
      students_that_participated.map do |s|
        s.question_response_sum_for lesson: lesson
      end.sort
    @min_question_response_sum, @max_question_response_sum = @sums.minmax

    percentages =
      students_that_participated.map do |s|
        s.question_response_percentage_for lesson: lesson
      end
    @average_percentage =
      percentages.size > 0 ? (percentages.sum / percentages.size) : 0
  end

  # N is a natural index. E.g. n: 1 = highest
  def nth_highest_question_response_sum(n: 4)
    return @sums[0] if n > @sums.size
    @sums[-n]
  end
end
