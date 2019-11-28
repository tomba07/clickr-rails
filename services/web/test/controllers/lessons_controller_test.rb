require 'test_helper'

class LessonsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @user = create(:user)
    sign_in @user
    @lesson = create(:lesson)
  end

  test "should get index" do
    get lessons_url
    assert_response :success
  end

  test "should get new" do
    get new_lesson_url
    assert_response :success
  end

  test "should create lesson" do
    new_lesson = build(:lesson)

    assert_difference('Lesson.count') do
      post lessons_url, params: { lesson: { school_class_id: new_lesson.school_class_id, name: new_lesson.name } }
    end

    assert_redirected_to lesson_url(Lesson.last)
  end

  test "should create lesson and redirect to previous page if requested" do
    new_lesson = build(:lesson)

    assert_difference('Lesson.count') do
      post lessons_url, params: { redirect_back: true, lesson: { school_class_id: new_lesson.school_class_id, name: new_lesson.name } }, headers: { HTTP_REFERER: 'http://clickr.ftes.de'}
    end

    assert_redirected_to 'http://clickr.ftes.de'
  end

  test "should create lesson using user's class" do
    new_school_class = create(:school_class)
    @user.update_attribute(:school_class, new_school_class)
    new_lesson = build(:lesson, school_class: nil)

    assert_difference('Lesson.count', 1) do
      post lessons_url, params: { lesson: { name: new_lesson.name } }
    end

    assert_equal new_school_class, assigns(:lesson).school_class
  end

  test "should show lesson" do
    get lesson_url(@lesson)
    assert_response :success
  end

  test "should get edit" do
    get edit_lesson_url(@lesson)
    assert_response :success
  end

  test "should update lesson" do
    patch lesson_url(@lesson), params: { lesson: { school_class_id: @lesson.school_class_id, name: @lesson.name } }
    assert_redirected_to lesson_url(@lesson)
  end

  test "should destroy lesson" do
    skip 'dependent rows in other tables'

    assert_difference('Lesson.count', -1) do
      delete lesson_url(@lesson)
    end

    assert_redirected_to lessons_url
  end
end
