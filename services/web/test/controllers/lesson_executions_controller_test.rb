require 'test_helper'

class LessonExecutionsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @user = create(:user)
    sign_in @user
  end

  test 'should redirect to school classes if non selected' do
    get root_path
    assert_redirected_to school_classes_path
  end

  test 'should get index if current school class is selected' do
    school_class = create(:school_class)
    CurrentSchoolClass.set school_class

    get root_path
    assert_response :success
  end
end
