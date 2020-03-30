require 'rails_helper'

RSpec.describe StudentsController do
  login_user

  let(:student) { create(:student) }

  it 'gets index' do
    get :index
    expect(response).to have_http_status :success
  end

  it 'gets new' do
    get :new
    expect(response).to have_http_status :success
  end

  describe 'create' do
    it 'creates student' do
      new_student = build(:student)

      expect {
        post :create,
             params: {
               student: {
                 name: new_student.name,
                 school_class_id: new_student.school_class_id,
                 seat_col: new_student.seat_col,
                 seat_row: new_student.seat_row
               }
             }
      }.to change { Student.count }.by 1

      expect(response).to redirect_to student_url(Student.last)
    end

    it 'creates incomplete device mapping when creating student if requested' do
      new_student = build(:student)

      expect {
        post :create,
             params: {
               create_incomplete_mapping: true,
               student: {
                 name: new_student.name,
                 school_class_id: new_student.school_class_id,
                 seat_col: new_student.seat_col,
                 seat_row: new_student.seat_row
               }
             }
      }.to change { StudentDeviceMapping.count }.by 1

      expect(response).to redirect_to student_url(Student.last)
    end
  end

  it 'shows student' do
    get :show, params: { id: student.id }
    expect(response).to have_http_status :success
  end

  it 'gets edit' do
    get :edit, params: { id: student.id }
    expect(response).to have_http_status :success
  end

  it 'updates student' do
    patch :update,
          params: {
            id: student.id,
            student: {
              name: student.name,
              school_class_id: student.school_class_id,
              seat_col: student.seat_col,
              seat_row: student.seat_row
            }
          }
    expect(response).to redirect_to student_url(student)
  end

  describe 'adjust_score' do
    it 'adjusts score for most recent lesson' do
      lesson = student.school_class.most_recent_lesson_or_create

      expect {
        post :adjust_score, params: { id: student.id, amount: 2 }, as: :json
      }.to change { student.question_response_sum_for lesson: lesson }.by 2
    end

    it 'adjusts score for a specific lesson' do
      old_lesson = student.school_class.most_recent_lesson_or_create
      student.school_class.lessons << create(:lesson)

      expect {
        post :adjust_score,
             params: { id: student.id, lesson_id: old_lesson.id, amount: -1 },
             as: :json
      }.to change {
        student.question_response_sum_for lesson: old_lesson
      }.by -1
    end
  end

  it 'destroys student' do
    student # force lazy create
    expect { delete :destroy, params: { id: student.id } }.to change {
      Student.count
    }.by -1

    expect(response).to redirect_to students_url
  end
end
