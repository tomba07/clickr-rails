require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @user = create(:user)
    sign_in @user
  end

  test "should change school class and redirect to previous page" do
    school_class = create(:school_class)
    put users_school_class_url, params: { school_class_id: school_class.id }, headers: { HTTP_REFERER: 'http://clickr.ftes.de' }
    assert_redirected_to 'http://clickr.ftes.de'
    assert_equal @user.reload.school_class, school_class
  end

end
