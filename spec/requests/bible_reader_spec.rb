require "rails_helper"

RSpec.describe "Bible Reader", type: :request do
  it "renders the chapter entry page successfully" do
    get bible_enter_chapter_path

    expect(response).to have_http_status(:ok)
    expect(response.body).to include("Capítulo")
  end
end
