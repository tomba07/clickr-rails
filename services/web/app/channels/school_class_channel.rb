class SchoolClassChannel < ApplicationCable::Channel
  RESPONSE = 'response'.freeze
  MAPPING = 'mapping'.freeze
  SEATING_PLAN = 'seating_plan'.freeze
  STUDENT = 'student'.freeze
  QUESTION = 'question'.freeze

  def subscribed
    school_class = SchoolClass.find(params[:school_class_id])
    stream_for school_class
  end
end