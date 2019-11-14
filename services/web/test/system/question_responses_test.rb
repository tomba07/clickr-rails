require "application_system_test_case"

class QuestionResponsesTest < ApplicationSystemTestCase
  setup do
    @question_response = question_responses(:one)
  end

  test "visiting the index" do
    visit question_responses_url
    assert_selector "h1", text: "Question responses"
  end

  test "creating a Question response" do
    visit question_responses_url
    click_on "New Question response"

    fill_in "Class", with: @question_response.school_class_id
    fill_in "Click", with: @question_response.click_id
    fill_in "Lesson", with: @question_response.lesson_id
    fill_in "Question", with: @question_response.question_id
    fill_in "Student", with: @question_response.student_id
    click_on "Create Question response"

    assert_text "Question response was successfully created"
    click_on "Back"
  end

  test "updating a Question response" do
    visit question_responses_url
    click_on "Edit", match: :first

    fill_in "Class", with: @question_response.school_class_id
    fill_in "Click", with: @question_response.click_id
    fill_in "Lesson", with: @question_response.lesson_id
    fill_in "Question", with: @question_response.question_id
    fill_in "Student", with: @question_response.student_id
    click_on "Update Question response"

    assert_text "Question response was successfully updated"
    click_on "Back"
  end

  test "destroying a Question response" do
    visit question_responses_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Question response was successfully destroyed"
  end
end
