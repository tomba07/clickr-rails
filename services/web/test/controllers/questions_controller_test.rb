require 'test_helper'

class QuestionsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @user = create(:user)
    sign_in @user
    @question = create(:question)
  end

  test "should get index" do
    get questions_url
    assert_response :success
  end

  test "should get new" do
    get new_question_url
    assert_response :success
  end

  test "should create question" do
    new_question = build(:question)

    assert_difference('Question.count') do
      post questions_url, params: {question: {school_class_id: new_question.school_class_id, lesson_id: new_question.lesson_id, name: new_question.name}}
    end

    assert_redirected_to question_url(Question.last)
  end

  test "should create question using user's class and most recent lesson (newly created)" do
    new_school_class = create(:school_class)
    @user.update_attribute(:school_class, new_school_class)

    assert_difference('Lesson.count', 1) do
      post questions_url, params: {question: {name: @question.name}}
    end

    assert_equal new_school_class, assigns(:question).school_class
  end

  test "should show question" do
    get question_url(@question)
    assert_response :success
  end

  test "should get edit" do
    get edit_question_url(@question)
    assert_response :success
  end

  test "should update question" do
    patch question_url(@question), params: {question: {school_class_id: @question.school_class_id, lesson_id: @question.lesson_id, name: @question.name}}
    assert_redirected_to question_url(@question)
  end

  test "should destroy question" do
    skip 'dependent rows in other tables'
    assert_difference('Question.count', -1) do
      delete question_url(@question)
    end

    assert_redirected_to questions_url
  end
end
