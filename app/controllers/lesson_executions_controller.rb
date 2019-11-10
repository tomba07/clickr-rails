class LessonExecutionsController < ApplicationController
  def index
    @school_class = current_user.school_class or raise ActionController::BadRequest, 'User has no school class selected'
    @lesson = @school_class.most_recent_lesson_or_create
    @suggest_creating_new_lesson = @school_class.suggest_creating_new_lesson?
    @students = @school_class.students
    @floor_plan = @school_class.floor_plan
  end
end
