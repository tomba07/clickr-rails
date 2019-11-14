require "application_system_test_case"

class StudentsTest < ApplicationSystemTestCase
  include Devise::Test::IntegrationHelpers

  setup do
    sign_in users(:one)
    @student = students(:one)
  end

  test "visiting the index" do
    visit students_url
    assert_selector "h1", text: "Students"
  end

  test "creating a Student" do
    visit students_url
    click_on "New Student"

    fill_in "Name", with: @student.name
    select @student.school_class.name, from: "student_school_class_id"
    fill_in "Seat col", with: @student.seat_col
    fill_in "Seat row", with: @student.seat_row
    click_on "Save"

    assert_text "Student was successfully created"
    click_on "Back"
  end

  test "updating a Student" do
    visit students_url
    click_on "Edit", match: :first

    fill_in "Name", with: @student.name
    select @student.school_class.name, from: "student_school_class_id"
    fill_in "Seat col", with: @student.seat_col
    fill_in "Seat row", with: @student.seat_row
    click_on "Save"

    assert_text "Student was successfully updated"
    click_on "Back"
  end

  test "destroying a Student" do
    skip 'dependent rows in other tables'
    visit students_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Student was successfully destroyed"
  end
end
