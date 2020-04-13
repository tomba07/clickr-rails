require 'rails_helper'

RSpec.describe LessonEvaluationsController do
  login_user
  let(:lesson) { create(:lesson) }
  let(:school_class) { lesson.school_class }

  describe 'show' do
    it 'runs' do
      get :show, params: { lesson_id: lesson.id }
      expect(response).to have_http_status :success
    end

    it 'does not change existing benchmark' do
      lesson.update!(benchmark: 1337)
      get :show, params: { lesson_id: lesson.id }
      expect(lesson.reload.benchmark).to eq 1337
    end

    it 'initializes benchmark (4 out of 5 students have score 1, remaining student has score 0)' do
      students = create_list(:student, 5, school_class: school_class)
      question = create(:question, school_class: school_class, lesson: lesson)
      # 4 out of 5 students have score 1.
      students[0..3].each do |s|
        create(
          :question_response,
          question: question,
          lesson: lesson,
          school_class: school_class,
          student: s
        )
      end
      lesson.update!(benchmark: nil)

      get :show, params: { lesson_id: lesson.id }
      evaluation = Clickr::LessonEvaluation.new(lesson.reload)

      expect(lesson.has_benchmark).to eq true
      expect(evaluation.average_percentage).to be_within(0.1).of 0.77
    end
  end

  it 'updates benchmark' do
    put :update_benchmark, params: { lesson_id: lesson.id, benchmark: 3 }
    expect(3).to eq lesson.reload.benchmark
  end
end
