class SeatingPlansController < ApplicationController
  layout false

  before_action :set_school_class, only: [:show, :update]
  before_action :set_seating_plan, only: [:show]
  before_action :set_edit, only: [:show, :update]

  def show
  end

  def update
    seating_plan = seating_plan_params.map { |s| s.to_h.symbolize_keys }
    @school_class.update_seats seating_plan
    @seating_plan = SeatingPlan.new(@school_class.students)
    respond_to do |format|
    format.html { render action: :show, layout: false }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_school_class
    @school_class = SchoolClass.find(params[:school_class_id])
  end

  def set_seating_plan
    @seating_plan = SeatingPlan.new(@school_class.students)
  end

  def set_edit
    @edit = params[:edit_seating_plan] == 'true'
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def seating_plan_params
    params.permit(students: [:student_id, :seat_row, :seat_col]).require(:students)
  end
end
