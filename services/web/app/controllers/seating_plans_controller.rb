# TODO Refactor: Split to lesson evaluation and lesson execution
class SeatingPlansController < ApplicationController
  layout false

  before_action :set_school_class, only: %i[show update]
  before_action :set_lesson, only: :show
  before_action :set_seating_plan, only: %i[show]
  before_action :set_edit, only: %i[show update]
  before_action :set_browser_window_id, only: %i[show update]

  # Partial rendering, injected into "give lesson" by JS controller
  def show
    @context = params[:context]
  end

  def update
    seating_plan = seating_plan_params.map { |s| s.to_h.symbolize_keys }
    @school_class.update_seats seating_plan
    @seating_plan = Clickr::SeatingPlan.new(@school_class)
    SchoolClassChannel.broadcast_to(
      @school_class,
      type: SchoolClassChannel::SEATING_PLAN,
      browser_window_id: @browser_window_id
    )

    respond_to { |format| format.html { render action: :show, layout: false } }
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_school_class
    @school_class = SchoolClass.find(params[:school_class_id])
  end

  def set_lesson
    @lesson = Lesson.find_by(id: params[:lesson_id])
  end

  def set_seating_plan
    @seating_plan = Clickr::SeatingPlan.new(@school_class)
  end

  def set_edit
    @edit = params[:edit_seating_plan] == 'true'
  end

  def set_browser_window_id
    @browser_window_id = params[:browser_window_id] || SecureRandom.uuid
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def seating_plan_params
    params.permit(students: %i[student_id seat_row seat_col]).require(:students)
  end
end
