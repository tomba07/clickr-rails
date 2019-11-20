class LessonExecutionsController < ApplicationController
  def index
    @school_class = current_user.school_class or (flash[:notice] = t('.select_school_class_notice') and redirect_to school_classes_path and return)
    @lesson = @school_class.most_recent_lesson_or_create
    @suggest_creating_new_lesson = @school_class.suggest_creating_new_lesson?
    @students = @school_class.students
  end
end
