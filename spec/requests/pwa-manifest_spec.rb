require "rails_helper"

RSpec.describe "PWA manifest", type: :request do
  it "exposes an installable PWA manifest" do
    get "/manifest.json"

    expect(response).to have_http_status(:ok)
    expect(response.content_type).to include("application/json")

    manifest = JSON.parse(response.body)
    expect(manifest["display"]).to eq("standalone")
    expect(manifest["icons"].map { |i| i["sizes"] })
      .to include("192x192", "512x512")
  end
end
