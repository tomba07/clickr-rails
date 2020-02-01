class Clickr::LessonEvaluation
  attr_reader :min_question_response_sum, :max_question_response_sum

  def initialize(lesson)
    school_class = lesson.school_class
    students = school_class.students
    @sums = students.map { |s| s.question_response_sum_for lesson: lesson }.sort
    @min_question_response_sum, @max_question_response_sum = @sums.minmax
  end

  # N is a natural index. E.g. n: 1 = highest
  def nth_highest_question_response_sum(n: 4)
    return @sums[0] if n > @sums.size
    @sums[-n]
  end
end
