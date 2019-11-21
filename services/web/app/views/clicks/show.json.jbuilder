json.partial! "clicks/click", click: @click
if @question_response
  json.question_response do
    json.partial! "question_responses/question_response", question_response: @question_response, url: false
  end
end

if @student_device_mapping
  json.student_device_mapping do
    json.partial! "student_device_mappings/student_device_mapping", student_device_mapping: @student_device_mapping, url: false
  end
end
