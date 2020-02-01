json.partial! "clicks/click", click: @click

json.question_responses do
  json.partial! "question_responses/question_response", collection: @responses, url: false, as: :question_response
end

if @mapping
  json.student_device_mapping do
    json.partial! "student_device_mappings/student_device_mapping", student_device_mapping: @mapping, url: false
  end
end
