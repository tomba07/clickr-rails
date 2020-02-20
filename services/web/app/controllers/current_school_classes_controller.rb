class CurrentSchoolClassesController < ApplicationController
  def update
    school_class_id = params.dig(:current_school_class, :school_class_id)
    school_class = SchoolClass.find(school_class_id)
    CurrentSchoolClass.set(school_class)
    redirect_back fallback_location: root_path, notice: t('.notice')
  end
end
