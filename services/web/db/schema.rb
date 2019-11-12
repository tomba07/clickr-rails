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

ActiveRecord::Schema.define(version: 2019_11_06_191945) do

  create_table "lessons", force: :cascade do |t|
    t.text "title"
    t.integer "school_class_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["school_class_id"], name: "index_lessons_on_school_class_id"
  end

  create_table "questions", force: :cascade do |t|
    t.integer "school_class_id", null: false
    t.integer "lesson_id", null: false
    t.string "text"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["lesson_id"], name: "index_questions_on_lesson_id"
    t.index ["school_class_id"], name: "index_questions_on_school_class_id"
  end

  create_table "questions_students", id: false, force: :cascade do |t|
    t.integer "question_id", null: false
    t.integer "student_id", null: false
  end

  create_table "school_classes", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "students", force: :cascade do |t|
    t.integer "school_class_id", null: false
    t.string "name"
    t.integer "seat_row"
    t.integer "seat_col"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
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
  add_foreign_key "questions", "lessons"
  add_foreign_key "questions", "school_classes"
  add_foreign_key "students", "school_classes"
  add_foreign_key "users", "school_classes"
end