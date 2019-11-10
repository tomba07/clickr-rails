require 'test_helper'

class QuestionsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    sign_in users(:one)
    @question = questions(:one)
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
    assert_difference('Question.count') do
      post questions_url, params: { question: { school_class_id: @question.school_class_id, lesson_id: @question.lesson_id, text: @question.text } }
    end

    assert_redirected_to question_url(Question.last)
  end

  test "should create question using user's class and most recent lesson (newly created)" do
    users(:one).update_attribute(:school_class, school_classes(:two))

    assert_difference('Lesson.count', 1) do
      post questions_url, params: { question: { text: @question.text } }
    end

    assert_equal school_classes(:two), assigns(:question).school_class
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
    patch question_url(@question), params: { question: { school_class_id: @question.school_class_id, lesson_id: @question.lesson_id, text: @question.text } }
    assert_redirected_to question_url(@question)
  end

  test "should destroy question" do
    assert_difference('Question.count', -1) do
      delete question_url(@question)
    end

    assert_redirected_to questions_url
  end
end
