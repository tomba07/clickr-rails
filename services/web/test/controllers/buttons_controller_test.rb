require 'test_helper'

class ButtonsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get buttons_index_url
    assert_response :success
  end

end
