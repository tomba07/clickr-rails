class LessonEvaluationsController < ApplicationController
  before_action :set_lesson, only: %i[show update_benchmark]

  def show
    @school_class = @lesson.school_class
    @seating_plan = Clickr::SeatingPlan.new(@school_class)
    @evaluation = Clickr::LessonEvaluation.new(@lesson)
    @benchmark_max =
      (@evaluation.max_question_response_sum || 0) +
        Rails.application.config.clickr.benchmark_buffer_on_top_of_max_sum
  end

  def update_benchmark
    @lesson.benchmark = params[:benchmark]
    @lesson.save!
  end

  private

  def set_lesson
    @lesson = Lesson.find(params[:lesson_id])
  end
end
