require 'test_helper'

class LessonExecutionsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    sign_in users(:one)
  end

  test "should get index" do
    get lesson_executions_url
    assert_response :success
  end

end
