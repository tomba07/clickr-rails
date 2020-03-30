require 'rails_helper'

RSpec.describe LessonExecutionsController do
  login_user

  it 'redirects to school classes if non selected' do
    get :show
    expect(response).to redirect_to school_classes_path
  end

  it 'gets show if current school class is selected' do
    school_class = create(:school_class)
    CurrentSchoolClass.set school_class

    get :show
    expect(response).to have_http_status :success
    expect(response).to render_template :show
  end
end
