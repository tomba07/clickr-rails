require 'test_helper'

class LessonEvaluationsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @user = create(:user)
    sign_in(@user)
    @lesson = create(:lesson)
  end

  test 'should get show' do
    get lesson_evaluate_path(@lesson.id)
    assert_response :success
  end

  test 'should update benchmark' do
    #TODO Implement
  end
end
