require "application_system_test_case"

class SchoolClassesTest < ApplicationSystemTestCase
  setup do
    @school_class = school_classes(:one)
  end

  test "visiting the index" do
    visit school_classes_url
    assert_selector "h1", text: "School Classes"
  end

  test "creating a School class" do
    visit school_classes_url
    click_on "New School Class"

    fill_in "Name", with: @school_class.name
    click_on "Create School class"

    assert_text "School class was successfully created"
    click_on "Back"
  end

  test "updating a School class" do
    visit school_classes_url
    click_on "Edit", match: :first

    fill_in "Name", with: @school_class.name
    click_on "Update School class"

    assert_text "School class was successfully updated"
    click_on "Back"
  end

  test "destroying a School class" do
    visit school_classes_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "School class was successfully destroyed"
  end
end
