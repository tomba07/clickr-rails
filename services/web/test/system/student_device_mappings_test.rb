require "application_system_test_case"

class StudentDeviceMappingsTest < ApplicationSystemTestCase
  setup do
    @student_device_mapping = student_device_mappings(:one)
  end

  test "visiting the index" do
    visit student_device_mappings_url
    assert_selector "h1", text: "Student Device Mappings"
  end

  test "creating a Student device mapping" do
    visit student_device_mappings_url
    click_on "New Student Device Mapping"

    fill_in "Device", with: @student_device_mapping.device_id
    fill_in "Device type", with: @student_device_mapping.device_type
    fill_in "Student", with: @student_device_mapping.student_id
    click_on "Create Student device mapping"

    assert_text "Student device mapping was successfully created"
    click_on "Back"
  end

  test "updating a Student device mapping" do
    visit student_device_mappings_url
    click_on "Edit", match: :first

    fill_in "Device", with: @student_device_mapping.device_id
    fill_in "Device type", with: @student_device_mapping.device_type
    fill_in "Student", with: @student_device_mapping.student_id
    click_on "Update Student device mapping"

    assert_text "Student device mapping was successfully updated"
    click_on "Back"
  end

  test "destroying a Student device mapping" do
    visit student_device_mappings_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Student device mapping was successfully destroyed"
  end
end
