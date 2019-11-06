require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    sign_in users(:one)
    @user = users(:one)
  end

  test "should change school class" do
    put users_school_class_url, params: { school_class_id: school_classes(:two).id }, headers: { "HTTP_REFERER" => "http://clickr.ftes.de" }
    assert_redirected_to 'http://clickr.ftes.de'
    assert_equal @user.reload.school_class, school_classes(:two)
  end

end
