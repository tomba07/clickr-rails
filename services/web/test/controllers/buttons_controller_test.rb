require 'test_helper'

class ButtonsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @user = create(:user)
    sign_in @user
  end

  test "should get index" do
    get buttons_url
    assert_response :success
  end

end
