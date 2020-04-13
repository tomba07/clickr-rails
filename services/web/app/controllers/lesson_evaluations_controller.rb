class LessonEvaluationsController < ApplicationController
  before_action :set_lesson, only: %i[show update_benchmark]

  def show
    @school_class = @lesson.school_class
    max_response_sum =
      Clickr::LessonEvaluation.new(@lesson).max_question_response_sum || 0

    if !@lesson.has_benchmark
      function = lambda do |benchmark|
        Clickr::LessonEvaluation.new(@lesson, benchmark: benchmark)
          .average_percentage
      end
      handle =
        Clickr::NumericalApproximation.new(
          function: function,
          x_min: 0.0,
          x_max: max_response_sum,
          y_target: 0.77
        )
      benchmark = handle.result.round(2)
      if handle.y_delta < 0.1
        @lesson.update!(benchmark: benchmark)
        flash.now[:notice] = t('.benchmark_initialized', benchmark: benchmark)
      else
        flash.now[:alert] = t('.benchmark_failed')
      end
    end

    @seating_plan = Clickr::SeatingPlan.new(@school_class)
    @evaluation = Clickr::LessonEvaluation.new(@lesson)
    @benchmark_max =
      max_response_sum +
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
