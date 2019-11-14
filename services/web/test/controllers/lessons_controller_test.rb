require 'test_helper'

class LessonsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    sign_in users(:one)
    @lesson = lessons(:one)
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
    assert_difference('Lesson.count') do
      post lessons_url, params: { lesson: { school_class_id: @lesson.school_class_id, name: @lesson.name } }
    end

    assert_redirected_to lesson_url(Lesson.last)
  end

  test "should create lesson and redirect to previous page if requested" do
    assert_difference('Lesson.count') do
      post lessons_url, params: { lesson: { redirect_to_previous_page: true, school_class_id: @lesson.school_class_id, name: @lesson.name } }, headers: { HTTP_REFERER: 'http://clickr.ftes.de'}
    end

    assert_redirected_to 'http://clickr.ftes.de'
  end

  test "should create lesson using user's class" do
    users(:one).update_attribute(:school_class, school_classes(:two))

    assert_difference('Lesson.count', 1) do
      post lessons_url, params: { lesson: { name: @lesson.name } }
    end

    assert_equal school_classes(:two), assigns(:lesson).school_class
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
    assert_difference('Lesson.count', -1) do
      delete question_url(questions(:one))
      delete question_url(questions(:two))
      delete lesson_url(@lesson)
    end

    assert_redirected_to lessons_url
  end
end
