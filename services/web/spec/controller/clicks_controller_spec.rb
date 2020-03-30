require 'rails_helper'

RSpec.describe ClicksController, type: :controller do
  login_user

  let(:click) { create(:click) }
  let(:school_class) { create(:school_class) }
  let(:lesson) { create(:lesson, school_class: school_class) }

  before(:each) { CurrentSchoolClass.set school_class }

  it 'gets index' do
    get :index
    expect(response).to have_http_status :success
  end

  it 'gets new' do
    get :new
    expect(response).to have_http_status :success
  end

  describe 'create' do
    it 'creates click' do
      new_click = create(:click)
      expect {
        post :create,
             params: {
               click: {
                 device_id: new_click.device_id,
                 device_type: new_click.device_type
               }
             }
      }.to change { Click.count }.by 1

      expect(response).to redirect_to click_url(assigns(:click))
    end

    %i[html json].each do |format|
      it "creates question response (format: #{format})" do
        create(:question, school_class: school_class, lesson: lesson)
        student = create(:student, school_class: school_class)
        create(
          :student_device_mapping,
          school_class: school_class,
          student: student,
          device_type: 'rfid',
          device_id: '123'
        )

        expect {
          post :create,
               as: format,
               params: { click: { device_type: 'rfid', device_id: '123' } }
        }.to change { QuestionResponse.count }.by(1)
      end
    end

    it 'does not create question response for second click' do
      create(:question, school_class: school_class, lesson: lesson)
      student = create(:student, school_class: school_class)
      create(
        :student_device_mapping,
        school_class: school_class,
        student: student,
        device_type: 'rfid',
        device_id: '123'
      )

      expect {
        post :create,
             params: { click: { device_type: 'rfid', device_id: '123' } }
        post :create,
             params: { click: { device_type: 'rfid', device_id: '123' } }
      }.to change { QuestionResponse.count }.by 1
    end

    it 'should not create question response if question does allow response' do
      create(
        :question,
        school_class: school_class, lesson: lesson, response_allowed: false
      )
      student = create(:student, school_class: school_class)
      create(
        :student_device_mapping,
        school_class: school_class,
        student: student,
        device_type: 'rfid',
        device_id: '123'
      )

      expect {
        post :create,
             params: { click: { device_type: 'rfid', device_id: '123' } }
      }.not_to change { QuestionResponse.count }
    end

    %i[html json].each do |format|
      it "updates incomplete mapping but does not create question response (format: #{
           format
         }" do
        student = create(:student, school_class: school_class)
        incomplete_mapping =
          create(
            :student_device_mapping,
            student: student,
            device_type: nil,
            device_id: nil,
            school_class: school_class
          )

        expect {
          post :create,
               params: { click: { device_type: 'rfid', device_id: '123' } }
        }.not_to change { QuestionResponse.count }

        incomplete_mapping.reload
        expect(incomplete_mapping.device_type).to eq 'rfid'
        expect(incomplete_mapping.device_id).to eq 'rfid:123'
      end
    end

    it 'skips an incomplete mapping that would lead to a double mapping of a device in one class' do
      student_one = create(:student, school_class: school_class)
      incomplete_mapping =
        create(
          :student_device_mapping,
          # TODO Use 'incomplete' trait
          student: student_one,
          device_type: nil,
          device_id: nil,
          school_class: school_class
        )

      student_two = create(:student, school_class: school_class)
      create(
        :student_device_mapping,
        school_class: school_class,
        student: student_two,
        device_type: 'rfid',
        device_id: '123'
      )

      expect {
        post :create,
             params: { click: { device_type: 'rfid', device_id: '123' } }
      }.to change { Click.count }.by 1

      incomplete_mapping.reload
      assert_equal true, incomplete_mapping.incomplete?
    end

    it 'updates incomplete mapping even if the device ID is already mapped in another class' do
      student = create(:student, school_class: school_class)
      complete_mapping =
        create(:student_device_mapping, device_type: 'rfid', device_id: '123')
      incomplete_mapping =
        create(
          :student_device_mapping,
          school_class: school_class,
          student: student,
          device_type: nil,
          device_id: nil
        )

      post :create, params: { click: { device_type: 'rfid', device_id: '123' } }

      incomplete_mapping.reload
      expect(incomplete_mapping.device_type).to eq 'rfid'
      expect(incomplete_mapping.device_id).to eq 'rfid:123'
    end

    it 'leaves device ID unchanged if it is already prefixed with type' do
      new_click = create(:click, device_type: 'rfid', device_id: 'rfid:123')
      post :create,
           as: :json,
           params: {
             click: {
               device_id: new_click.device_id,
               device_type: new_click.device_type
             }
           }

      expect(assigns(:click).device_id).to eq('rfid:123')
    end

    it 'prefixes device ID with type' do
      new_click = create(:click, device_type: 'rfid', device_id: '123')
      post :create,
           as: :json,
           params: {
             click: {
               device_id: new_click.device_id,
               device_type: new_click.device_type
             }
           }

      expect(assigns(:click).device_id).to eq 'rfid:123'
    end

    it 'does not require authentication' do
      sign_out user
      new_click = create(:click)
      post :create,
           as: :json,
           params: {
             click: {
               device_id: new_click.device_id,
               device_type: new_click.device_type
             }
           }

      expect(response).to have_http_status :created
    end
  end

  it 'shows click' do
    get :show, params: { id: click.id }
    expect(response).to have_http_status :success
  end

  it 'shows edit' do
    get :edit, params: { id: click.id }
    expect(response).to have_http_status :success
  end

  it 'updates click' do
    patch :update,
          params: {
            id: click.id,
            click: {
              device_id: click.device_id, device_type: click.device_type
            }
          }
    expect(response).to redirect_to click_url(click)
  end

  it 'destroys click' do
    click # Force lazy loading
    expect { delete :destroy, params: { id: click.id } }.to change {
      Click.count
    }.by -1

    expect(response).to redirect_to clicks_url
  end
end
