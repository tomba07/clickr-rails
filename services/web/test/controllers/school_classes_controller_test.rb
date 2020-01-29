require 'test_helper'

class SchoolClassesControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @user = create(:user)
    sign_in @user
    @school_class = create(:school_class)
  end

  test 'should get index' do
    get school_classes_url
    assert_response :success
  end

  test 'should get new' do
    get new_school_class_url
    assert_response :success
  end

  test 'should create school_class' do
    new_school_class = build(:school_class)

    assert_difference('SchoolClass.count') do
      post school_classes_url,
           params: { school_class: { name: new_school_class.name } }
    end

    assert_redirected_to school_class_url(SchoolClass.last)
  end

  test 'should create school_class by cloning an existing class' do
    old_school_class = create(:school_class)
    old_student = create(:student, school_class: old_school_class)
    create(
      :student_device_mapping,
      school_class: old_school_class, student: old_student
    )
    new_school_class = build(:school_class)

    assert_difference(
      %w[SchoolClass.count Student.count StudentDeviceMapping.count],
      1
    ) do
      post school_classes_url,
           params: {
             school_class: { name: new_school_class.name },
             clone_school_class: { id: old_school_class.id }
           }
    end
  end

  test 'should show school_class' do
    get school_class_url(@school_class)
    assert_response :success
  end

  test 'should get edit' do
    get edit_school_class_url(@school_class)
    assert_response :success
  end

  test 'should update school_class' do
    patch school_class_url(@school_class),
          params: { school_class: { name: @school_class.name } }
    assert_redirected_to school_class_url(@school_class)
  end

  test 'should destroy school_class' do
    assert_difference('SchoolClass.count', -1) do
      delete school_class_url(@school_class)
    end

    assert_redirected_to school_classes_url
  end
end
