class SchoolClassChannel < ApplicationCable::Channel
  CLICK = 'click'.freeze
  SEATING_PLAN = 'seating_plan'.freeze
  STUDENT = 'student'.freeze
  QUESTION = 'question'.freeze
  LESSON = 'lesson'.freeze

  def subscribed
    school_class = SchoolClass.find(params[:school_class_id])
    stream_for school_class
  end
end
