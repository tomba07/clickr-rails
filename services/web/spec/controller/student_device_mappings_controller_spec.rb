require 'rails_helper'

RSpec.describe StudentDeviceMappingsController, type: :controller do
  login_user

  let(:student_device_mapping) { create(:student_device_mapping) }

  it 'gets index' do
    get :index
    expect(response).to have_http_status :success
  end

  it 'gets new' do
    get :new
    expect(response).to have_http_status :success
  end

  it 'creates student_device_mapping' do
    new_student_device_mapping = build(:student_device_mapping)

    expect {
      post :create,
           params: {
             student_device_mapping: {
               device_id: new_student_device_mapping.device_id,
               device_type: new_student_device_mapping.device_type,
               student_id: new_student_device_mapping.student_id,
               school_class_id: new_student_device_mapping.school_class_id
             }
           }
    }.to change { StudentDeviceMapping.count }.by 1

    expect(response).to redirect_to student_device_mapping_url(
                  StudentDeviceMapping.last
                )
  end

  it 'shows student_device_mapping' do
    get :show, params: { id: student_device_mapping.id }
    expect(response).to have_http_status :success
  end

  it 'gets edit' do
    get :edit, params: { id: student_device_mapping.id }
    expect(response).to have_http_status :success
  end

  it 'updates student_device_mapping' do
    patch :update,
          params: {
            id: student_device_mapping.id,
            student_device_mapping: {
              device_id: student_device_mapping.device_id,
              device_type: student_device_mapping.device_type,
              student_id: student_device_mapping.student_id
            }
          }
    expect(response).to redirect_to student_device_mapping_url(
                  student_device_mapping
                )
  end

  it 'destroys student_device_mapping' do
    student_device_mapping # force lazy create

    expect {
      delete :destroy, params: { id: student_device_mapping.id }
    }.to change { StudentDeviceMapping.count }.by -1

    expect(response).to redirect_to student_device_mappings_url
  end
end
