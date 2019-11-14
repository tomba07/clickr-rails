require "application_system_test_case"

class SchoolClassesTest < ApplicationSystemTestCase
  include Devise::Test::IntegrationHelpers

  setup do
    sign_in users(:one)
    @school_class = school_classes(:one)
  end

  test "visiting the index" do
    visit school_classes_url
    assert_selector "h1", text: "Classes"
  end

  test "creating a School class" do
    visit school_classes_url
    click_on "New School class"

    fill_in "Name", with: @school_class.name
    click_on "Save"

    assert_text "School class was successfully created"
    click_on "Back"
  end

  test "updating a School class" do
    visit school_classes_url
    click_on "Edit", match: :first

    fill_in "Name", with: @school_class.name
    click_on "Save"

    assert_text "School class was successfully updated"
    click_on "Back"
  end

  test "destroying a School class" do
    skip 'dependent rows in other tables'
    visit school_classes_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "School class was successfully destroyed"
  end
end
