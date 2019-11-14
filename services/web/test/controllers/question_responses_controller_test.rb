require 'test_helper'

class QuestionResponsesControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @user = create(:user)
    sign_in @user
    @question_response = create(:question_response)
  end

  test "should get index" do
    get question_responses_url
    assert_response :success
  end

  test "should get new" do
    get new_question_response_url
    assert_response :success
  end

  test "should create question_response" do
    new_question_response = build(:question_response)

    assert_difference('QuestionResponse.count') do
      post question_responses_url, params: { question_response: { school_class_id: new_question_response.school_class_id, click_id: new_question_response.click_id, lesson_id: new_question_response.lesson_id, question_id: new_question_response.question_id, student_id: new_question_response.student_id } }
    end

    assert_redirected_to question_response_url(QuestionResponse.last)
  end

  test "should show question_response" do
    get question_response_url(@question_response)
    assert_response :success
  end

  test "should get edit" do
    get edit_question_response_url(@question_response)
    assert_response :success
  end

  test "should update question_response" do
    patch question_response_url(@question_response), params: { question_response: { class_id: @question_response.school_class_id, click_id: @question_response.click_id, lesson_id: @question_response.lesson_id, question_id: @question_response.question_id, student_id: @question_response.student_id } }
    assert_redirected_to question_response_url(@question_response)
  end

  test "should destroy question_response" do
    assert_difference('QuestionResponse.count', -1) do
      delete question_response_url(@question_response)
    end

    assert_redirected_to question_responses_url
  end
end
