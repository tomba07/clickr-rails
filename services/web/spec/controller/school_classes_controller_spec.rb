require 'rails_helper'

RSpec.describe SchoolClassesController, type: :controller do
  login_user

  let(:school_class) { create(:school_class) }

  it 'gets index' do
    get :index
    expect(response).to have_http_status :success
  end

  it 'gets new' do
    get :new
    expect(response).to have_http_status :success
  end

  describe 'create' do
    it 'creates school_class' do
      new_school_class = build(:school_class)

      expect {
        post :create, params: { school_class: { name: new_school_class.name } }
      }.to change { SchoolClass.count }.by 1

      expect(response).to redirect_to school_class_url(SchoolClass.last)
    end

    it 'creates school_class by cloning an existing class' do
      old_school_class = create(:school_class)
      old_student = create(:student, school_class: old_school_class)
      create(
        :student_device_mapping,
        school_class: old_school_class, student: old_student
      )
      new_school_class = build(:school_class)

      expect {
        post :create,
             params: {
               school_class: { name: new_school_class.name },
               clone_school_class: { id: old_school_class.id }
             }
      }.to change { SchoolClass.count }.by(1).and change { Student.count }.by(
                         1
                       ).and change { StudentDeviceMapping.count }.by(1)
    end
  end

  it 'shows school_class' do
    get :show, params: { id: school_class.id }
    expect(response).to have_http_status :success
  end

  it 'gets edit' do
    get :edit, params: { id: school_class }
    expect(response).to have_http_status :success
  end

  it 'updates school_class' do
    patch :update,
          params: {
            id: school_class, school_class: { name: school_class.name }
          }
    expect(response).to redirect_to school_class_url(school_class)
  end

  it 'destroys school_class' do
    school_class # trigger lazy create
    expect { delete :destroy, params: { id: school_class } }.to change {
      SchoolClass.count
    }.by -1

    expect(response).to redirect_to school_classes_url
  end
end
