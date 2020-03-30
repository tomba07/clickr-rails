require 'rails_helper'

RSpec.describe LessonsController, type: :controller do
  login_user

  let(:lesson) { create(:lesson) }

  it 'gets index' do
    get lessons_url
    expect(response).to have_http_status :success
  end

  it 'gets new' do
    get new_lesson_url
    expect(response).to have_http_status :success
  end

  it 'creates lesson' do
    new_lesson = build(:lesson)

    assert_difference('Lesson.count') do
      post lessons_url,
           params: {
             lesson: {
               school_class_id: new_lesson.school_class_id,
               name: new_lesson.name
             }
           }
    end

    expect(response).to redirect_to lesson_url(Lesson.last)
  end

  it 'creates lesson and redirect to previous page if requested' do
    new_lesson = build(:lesson)

    assert_difference('Lesson.count') do
      post lessons_url,
           params: {
             redirect_back: true,
             lesson: {
               school_class_id: new_lesson.school_class_id,
               name: new_lesson.name
             }
           },
           headers: { HTTP_REFERER: 'http://clickr.ftes.de' }
    end

    expect(response).to redirect_to 'http://clickr.ftes.de'
  end

  it 'creates lesson using current school class' do
    new_school_class = create(:school_class)
    CurrentSchoolClass.set new_school_class
    new_lesson = build(:lesson, school_class: nil)

    assert_difference('Lesson.count', 1) do
      post lessons_url, params: { lesson: { name: new_lesson.name } }
    end

    assert_equal new_school_class, assigns(:lesson).school_class
  end

  it 'shows lesson' do
    get lesson_url(@lesson)
    expect(response).to have_http_status :success
  end

  it 'gets edit' do
    get edit_lesson_url(@lesson)
    expect(response).to have_http_status :success
  end

  it 'updates lesson' do
    patch lesson_url(@lesson),
          params: {
            lesson: {
              school_class_id: @lesson.school_class_id, name: @lesson.name
            }
          }
    expect(response).to redirect_to lesson_url(@lesson)
  end

  it 'destroys lesson' do
    assert_difference('Lesson.count', -1) { delete lesson_url(@lesson) }

    expect(response).to redirect_to lessons_url
  end
end
