class LessonExecutionsController < ApplicationController
  def show
    @school_class = current_user.school_class or (flash[:notice] = t('.select_school_class_notice') and redirect_to school_classes_path and return)
    @seating_plan = SeatingPlan.new(@school_class.students)
    @edit = params['edit-seating-plan'] == 'true'
    @lesson = @school_class.most_recent_lesson_or_create
    @suggest_creating_new_lesson = @school_class.suggest_creating_new_lesson?
  end
end
