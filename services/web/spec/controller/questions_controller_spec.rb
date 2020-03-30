require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  login_user

  let(:question) { create(:question) }

  it 'gets index' do
    get :index
    expect(response).to have_http_status :success
  end

  it 'gets new' do
    get :new
    expect(response).to have_http_status :success
  end

  describe 'create' do
    it 'creates question' do
      new_question = build(:question)

      expect {
        post :create,
             params: {
               question: {
                 school_class_id: new_question.school_class_id,
                 lesson_id: new_question.lesson_id,
                 name: new_question.name
               }
             }
      }.to change { Question.count }.by 1

      expect(response).to redirect_to question_url(Question.last)
    end

    it "creates question using user's class and most recent lesson (newly created)" do
      new_school_class = create(:school_class)
      CurrentSchoolClass.set new_school_class
      question # force lazy create

      expect {
        post :create, params: { question: { name: question.name } }
        puts Lesson.all.inspect
      }.to change { Lesson.count }.by 1

      expect(assigns(:question).school_class).to eq new_school_class
    end
  end

  it 'shows question' do
    get :show, params: { id: question.id }
    expect(response).to have_http_status :success
  end

  it 'gets edit' do
    get :edit, params: { id: question.id }
    expect(response).to have_http_status :success
  end

  it 'updates question' do
    patch :update,
          params: {
            id: question.id,
            question: {
              school_class_id: question.school_class_id,
              lesson_id: question.lesson_id,
              name: question.name
            }
          }
    expect(response).to redirect_to question_url(question)
  end

  it 'stops question (response_allowed = false)' do
    post :stop, params: { id: question.id }
    expect(question.reload.response_allowed).to eq false
  end

  it 'destroys question' do
    question # force lazy create
    expect { delete :destroy, params: { id: question.id } }.to change {
      Question.count
    }.by -1

    expect(response).to redirect_to questions_url
  end
end
