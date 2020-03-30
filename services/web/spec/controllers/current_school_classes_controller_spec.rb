require 'rails_helper'

RSpec.describe CurrentSchoolClassesController do
  login_user

  it 'changes school class and redirects to previous page' do
    school_class = create(:school_class)
    put :update,
        params: { current_school_class: { school_class_id: school_class.id } }
    expect(CurrentSchoolClass.get).to eq school_class
  end
end
