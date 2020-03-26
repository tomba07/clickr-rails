require 'rails_helper'

RSpec.describe ButtonsController, type: :controller do
  login_user

  it "renders the index template" do
    get :index
    expect(response).to have_http_status :success
    expect(response).to render_template("index")
  end
end
