# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_02_01_162453) do

  create_table "clicks", force: :cascade do |t|
    t.string "device_id", null: false
    t.string "device_type", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["created_at"], name: "index_clicks_on_created_at", order: :desc
    t.index ["device_id"], name: "index_clicks_on_device_id"
    t.index ["device_type"], name: "index_clicks_on_device_type"
  end

  create_table "lessons", force: :cascade do |t|
    t.string "name", null: false
    t.integer "school_class_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "benchmark", default: 1, null: false
    t.index ["created_at"], name: "index_lessons_on_created_at", order: :desc
    t.index ["school_class_id", "name"], name: "index_lessons_on_school_class_id_and_name", unique: true
    t.index ["school_class_id"], name: "index_lessons_on_school_class_id"
  end

  create_table "question_responses", force: :cascade do |t|
    t.integer "score", default: 1, null: false
    t.integer "click_id"
    t.integer "student_id", null: false
    t.integer "question_id"
    t.integer "lesson_id", null: false
    t.integer "school_class_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["click_id"], name: "index_question_responses_on_click_id", unique: true
    t.index ["created_at"], name: "index_question_responses_on_created_at"
    t.index ["lesson_id"], name: "index_question_responses_on_lesson_id"
    t.index ["question_id", "student_id"], name: "index_question_responses_on_question_id_and_student_id", unique: true
    t.index ["question_id"], name: "index_question_responses_on_question_id"
    t.index ["school_class_id"], name: "index_question_responses_on_school_class_id"
    t.index ["student_id", "lesson_id"], name: "index_question_responses_on_student_id_and_lesson_id"
    t.index ["student_id"], name: "index_question_responses_on_student_id"
  end

  create_table "questions", force: :cascade do |t|
    t.integer "school_class_id", null: false
    t.integer "lesson_id", null: false
    t.string "name", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "score", default: 1, null: false
    t.boolean "response_allowed", default: true, null: false
    t.index ["created_at"], name: "index_questions_on_created_at", order: :desc
    t.index ["lesson_id"], name: "index_questions_on_lesson_id"
    t.index ["school_class_id"], name: "index_questions_on_school_class_id"
  end

  create_table "school_classes", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["name"], name: "index_school_classes_on_name", unique: true
  end

  create_table "student_device_mappings", force: :cascade do |t|
    t.integer "student_id", null: false
    t.integer "school_class_id", null: false
    t.string "device_id"
    t.string "device_type"
    t.boolean "incomplete", default: false, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["created_at"], name: "index_student_device_mappings_on_created_at", order: :desc
    t.index ["device_id"], name: "index_student_device_mappings_on_device_id"
    t.index ["device_type"], name: "index_student_device_mappings_on_device_type"
    t.index ["incomplete"], name: "index_student_device_mappings_on_incomplete"
    t.index ["school_class_id", "device_id"], name: "index_student_device_mappings_on_school_class_id_and_device_id", unique: true
    t.index ["school_class_id"], name: "index_student_device_mappings_on_school_class_id"
    t.index ["student_id"], name: "index_student_device_mappings_on_student_id"
  end

  create_table "students", force: :cascade do |t|
    t.integer "school_class_id", null: false
    t.string "name", null: false
    t.integer "seat_row", null: false
    t.integer "seat_col", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["school_class_id", "name"], name: "index_students_on_school_class_id_and_name", unique: true
    t.index ["school_class_id"], name: "index_students_on_school_class_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "school_class_id"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["school_class_id"], name: "index_users_on_school_class_id"
  end

  add_foreign_key "lessons", "school_classes"
  add_foreign_key "question_responses", "clicks"
  add_foreign_key "question_responses", "lessons"
  add_foreign_key "question_responses", "questions"
  add_foreign_key "question_responses", "school_classes"
  add_foreign_key "question_responses", "students"
  add_foreign_key "questions", "lessons"
  add_foreign_key "questions", "school_classes"
  add_foreign_key "student_device_mappings", "school_classes"
  add_foreign_key "student_device_mappings", "students"
  add_foreign_key "students", "school_classes"
  add_foreign_key "users", "school_classes"
end
