require 'rails_helper'

RSpec.describe LessonEvaluationsController, type: :controller do
  login_user
  let(:lesson) { create(:lesson) }

  it 'gets show' do
    get :show, params: { lesson_id: lesson.id }
    expect(response).to have_http_status :success
  end

  it 'updates benchmark' do
    put :update_benchmark, params: { lesson_id: lesson.id, benchmark: 3 }
    expect(3).to eq lesson.reload.benchmark
  end
end
