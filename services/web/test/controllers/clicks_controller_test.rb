require 'test_helper'

class ClicksControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    sign_in users(:one)
    @click = clicks(:one)
  end

  test "should get index" do
    get clicks_url
    assert_response :success
  end

  test "should get new" do
    get new_click_url
    assert_response :success
  end

  test "should create click" do
    assert_difference('Click.count') do
      post clicks_url, params: { click: { device_id: @click.device_id, device_type: @click.device_type } }
    end

    assert_redirected_to click_url(Click.last)
  end

  test "should show click" do
    get click_url(@click)
    assert_response :success
  end

  test "should get edit" do
    get edit_click_url(@click)
    assert_response :success
  end

  test "should update click" do
    patch click_url(@click), params: { click: { device_id: @click.device_id, device_type: @click.device_type } }
    assert_redirected_to click_url(@click)
  end

  test "should destroy click" do
    assert_difference('Click.count', -1) do
      delete click_url(@click)
    end

    assert_redirected_to clicks_url
  end
end
