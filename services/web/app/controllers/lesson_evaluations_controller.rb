class LessonEvaluationsController < ApplicationController
  before_action :set_lesson, only: %i[show update_benchmark]

  def show
    @school_class = @lesson.school_class
    @seating_plan = Clickr::SeatingPlan.new(@school_class)
    @evaluation = Clickr::LessonEvaluation.new(@lesson)
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
