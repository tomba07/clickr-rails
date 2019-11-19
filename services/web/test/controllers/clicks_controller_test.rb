require 'test_helper'

class ClicksControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @user = create(:user)
    sign_in @user
    @click = create(:click)
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
    new_click = create(:click)
    assert_difference('Click.count') do
      post clicks_url, params: { click: { device_id: new_click.device_id, device_type: new_click.device_type } }
    end

    assert_redirected_to click_url(Click.last)
  end

  test "should create click and leave ID unchanged if it is already prefixed with type" do
    new_click = create(:click, device_type: 'rfid', device_id: 'rfid:123')
    post clicks_url, as: :json, params: { click: { device_id: new_click.device_id, device_type: new_click.device_type } }

    assert_equal 'rfid:123', assigns(:click).device_id
  end

  test "should create click and prefix ID with type" do
    new_click = create(:click, device_id: '123')
    post clicks_url, as: :json, params: { click: { device_id: new_click.device_id, device_type: new_click.device_type } }

    assert_equal 'rfid:123', assigns(:click).device_id
  end

  test "should create click and not require authentication" do
    sign_out @user
    new_click = create(:click)
    post clicks_url, as: :json, params: { click: { device_id: new_click.device_id, device_type: new_click.device_type } }

    assert_equal 201, response.status
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
    skip 'dependent rows in other tables'
    assert_difference('Click.count', -1) do
      delete click_url(@click)
    end

    assert_redirected_to clicks_url
  end
end
