require 'rails_helper'

RSpec.describe LessonsController do
  login_user

  let(:lesson) { create(:lesson) }

  it 'gets index' do
    get :index
    expect(response).to have_http_status :success
  end

  it 'gets new' do
    get :new
    expect(response).to have_http_status :success
  end

  describe 'create' do
    it 'creates lesson' do
      new_lesson = build(:lesson)

      expect {
        post :create,
             params: {
               lesson: {
                 school_class_id: new_lesson.school_class_id,
                 name: new_lesson.name
               }
             }
      }.to change { Lesson.count }.by 1

      expect(response).to redirect_to lesson_url(Lesson.last)
    end

    it 'creates lesson using current school class' do
      new_school_class = create(:school_class)
      CurrentSchoolClass.set new_school_class
      new_lesson = build(:lesson, school_class: nil)

      post :create, params: { lesson: { name: new_lesson.name } }

      assert_equal new_school_class, assigns(:lesson).school_class
    end
  end

  it 'shows lesson' do
    get :show, params: { id: lesson.id }
    expect(response).to have_http_status :success
  end

  it 'gets edit' do
    get :edit, params: { id: lesson.id }
    expect(response).to have_http_status :success
  end

  it 'updates lesson' do
    patch :update,
          params: {
            id: lesson.id,
            lesson: {
              school_class_id: lesson.school_class_id, name: lesson.name
            }
          }
    expect(response).to redirect_to lesson_url(lesson)
  end

  it 'destroys lesson' do
    lesson # force lazy create
    expect { delete :destroy, params: { id: lesson.id } }.to change {
      Lesson.count
    }.by -1

    expect(response).to redirect_to lessons_url
  end
end
