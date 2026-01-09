require "rails_helper"

RSpec.describe "SavedVerses", type: :request do
  include Devise::Test::IntegrationHelpers

  let(:user) do
    User.create!(
      email: "test@example.com",
      password: "password123",
      password_confirmation: "password123"
    )
  end

  before { sign_in user }

  it "allows a user to create a saved verse" do
    post saved_verses_path, params: {
      saved_verse: {
        chapter: 5,
        verse: 5
      }
    }

    expect(response).to have_http_status(:redirect)
    expect(SavedVerse.count).to eq(1)
    expect(SavedVerse.last.user).to eq(user)
  end

  it "prevents another user from deleting the verse" do
    verse = SavedVerse.create!(
      user: user,
      chapter: 5,
      verse: 5
    )

    other_user = User.create!(
      email: "other@example.com",
      password: "password123",
      password_confirmation: "password123"
    )

    sign_out user
    sign_in other_user

    delete saved_verse_path(verse)

    expect(response).not_to have_http_status(:success)
  end
end
