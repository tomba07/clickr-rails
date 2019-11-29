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
      post clicks_url, params: {click: {device_id: new_click.device_id, device_type: new_click.device_type}}
    end

    assert_redirected_to click_url(Click.last)
  end

  [:html, :json].each do |format|
    test "should create click and question response (#{format})" do
      school_class = create(:school_class)
      lesson = create(:lesson, school_class: school_class)
      create(:question, school_class: school_class, lesson: lesson)
      student = create(:student, school_class: school_class)
      create(:student_device_mapping, school_class: school_class, student: student, device_type: 'rfid', device_id: '123')

      assert_difference 'Click.count', 1 do
        assert_difference 'QuestionResponse.count', 1 do
          post clicks_url, as: format, params: {click: {device_type: 'rfid', device_id: '123'}}
        end
      end
    end
  end

  test "should not create question response for second click" do
    school_class = create(:school_class)
    lesson = create(:lesson, school_class: school_class)
    create(:question, school_class: school_class, lesson: lesson)
    student = create(:student, school_class: school_class)
    create(:student_device_mapping, school_class: school_class, student: student, device_type: 'rfid', device_id: '123')

    assert_difference 'QuestionResponse.count', 1 do
      post clicks_url, params: {click: {device_type: 'rfid', device_id: '123'}}
      post clicks_url, params: {click: {device_type: 'rfid', device_id: '123'}}
    end
  end

  [:html, :json].each do |format|
    test "should create click and update incomplete mapping (#{format})" do
      student = create(:student)
      incomplete_mapping = create(:student_device_mapping, student: student, device_type: nil, device_id: nil)

      assert_difference 'Click.count', 1 do
        post clicks_url, as: format, params: {click: {device_type: 'rfid', device_id: '123'}}
      end

      incomplete_mapping.reload
      assert_equal 'rfid', incomplete_mapping.device_type
      assert_equal 'rfid:123', incomplete_mapping.device_id
    end
  end

  test "should not update incomplete mapping if the device ID is already mapped" do
    student = create(:student)
    complete_mapping = create(:student_device_mapping, device_type: 'rfid', device_id: '123')
    incomplete_mapping = create(:student_device_mapping, student: student, device_type: nil, device_id: nil)

    assert_difference 'Click.count', 1 do
      post clicks_url, params: {click: {device_type: 'rfid', device_id: '123'}}
    end

    incomplete_mapping.reload
    assert_equal true, incomplete_mapping.incomplete?
  end

  test "should create click and leave ID unchanged if it is already prefixed with type" do
    new_click = create(:click, device_type: 'rfid', device_id: 'rfid:123')
    post clicks_url, as: :json, params: {click: {device_id: new_click.device_id, device_type: new_click.device_type}}

    assert_equal 'rfid:123', assigns(:click).device_id
  end

  test "should create click and prefix ID with type" do
    new_click = create(:click, device_type: 'rfid', device_id: '123')
    post clicks_url, as: :json, params: {click: {device_id: new_click.device_id, device_type: new_click.device_type}}

    assert_equal 'rfid:123', assigns(:click).device_id
  end

  test "should create click and not require authentication" do
    sign_out @user
    new_click = create(:click)
    post clicks_url, as: :json, params: {click: {device_id: new_click.device_id, device_type: new_click.device_type}}

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
    patch click_url(@click), params: {click: {device_id: @click.device_id, device_type: @click.device_type}}
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
