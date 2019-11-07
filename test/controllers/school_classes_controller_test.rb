require 'test_helper'

class SchoolClassesControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    sign_in users(:one)
    @school_class = school_classes(:one)
  end

  test "should get index" do
    get school_classes_url
    assert_response :success
  end

  test "should get new" do
    get new_school_class_url
    assert_response :success
  end

  test "should create school_class" do
    assert_difference('SchoolClass.count') do
      post school_classes_url, params: { school_class: { name: @school_class.name } }
    end

    assert_redirected_to school_class_url(SchoolClass.last)
  end

  test "should show school_class" do
    get school_class_url(@school_class)
    assert_response :success
  end

  test "should get edit" do
    get edit_school_class_url(@school_class)
    assert_response :success
  end

  test "should update school_class" do
    patch school_class_url(@school_class), params: { school_class: { name: @school_class.name } }
    assert_redirected_to school_class_url(@school_class)
  end

  test "should destroy school_class" do
    assert_difference('SchoolClass.count', -1) do
      delete question_url(questions(:one))
      delete question_url(questions(:two))
      delete student_url(students(:one))
      delete student_url(students(:two))
      delete lesson_url(lessons(:one))
      delete lesson_url(lessons(:two))
      delete school_class_url(@school_class)
    end

    assert_redirected_to school_classes_url
  end
end
