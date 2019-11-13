json.extract! question_response, :id, :click_id, :student_id, :question_id, :lesson_id, :school_class_id, :created_at, :updated_at
json.url question_response_url(question_response, format: :json)
