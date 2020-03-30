require 'rails_helper'

RSpec.describe QuestionResponsesController, type: :controller do
  login_user

  let(:question_response) { create(:question_response) }

  it 'gets index' do
    get :index
    expect(response).to have_http_status :success
  end

  it 'gets new' do
    get :new
    expect(response).to have_http_status :success
  end

  it 'creates question_response' do
    new_question_response = build(:question_response)

    expect {
      post :create,
           params: {
             question_response: {
               school_class_id: new_question_response.school_class_id,
               click_id: new_question_response.click_id,
               lesson_id: new_question_response.lesson_id,
               question_id: new_question_response.question_id,
               student_id: new_question_response.student_id
             }
           }
    }.to change { QuestionResponse.count }.by 1

    expect(response).to redirect_to question_response_url(QuestionResponse.last)
  end

  it 'shows question_response' do
    get :show, params: { id: question_response.id }
    expect(response).to have_http_status :success
  end

  it 'gets edit' do
    get :show, params: { id: question_response.id }
    expect(response).to have_http_status :success
  end

  it 'updates question_response' do
    patch :update,
          params: {
            id: question_response.id,
            question_response: {
              class_id: question_response.school_class_id,
              click_id: question_response.click_id,
              lesson_id: question_response.lesson_id,
              question_id: question_response.question_id,
              student_id: question_response.student_id
            }
          }
    expect(response).to redirect_to question_response_url(question_response)
  end

  it 'destroys question_response' do
    question_response # trigger lazy creation
    expect { delete :destroy, params: { id: question_response.id } }.to change {
      QuestionResponse.count
    }.by -1

    expect(response).to redirect_to question_responses_url
  end
end
