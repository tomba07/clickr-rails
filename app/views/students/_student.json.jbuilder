json.extract! student, :id, :school_class_id, :name, :seat_row, :seat_col, :created_at, :updated_at
json.url student_url(student, format: :json)
