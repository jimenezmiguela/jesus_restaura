require "rails_helper"

RSpec.describe "Authentication", type: :request do
  it "requires authentication to access the user edit page" do
    get edit_user_registration_path
    expect(response).to redirect_to(new_user_session_path)
  end

  it "allows a signed-in user to access the user edit page" do
    user = User.create!(
      email: "test@example.com",
      password: "password123",
      password_confirmation: "password123"
    )

    sign_in user

    get edit_user_registration_path
    expect(response).to have_http_status(:ok)
  end
end
