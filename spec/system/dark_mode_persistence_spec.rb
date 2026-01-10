require "rails_helper"

RSpec.describe "Dark mode persistence", type: :system do

  it "renders with light theme by default" do
    visit root_path
    expect(page.html).to include('data-theme="light"')
  end

  it "includes persistence script for theme restoration" do
    visit root_path
    expect(page.html).to include("localStorage.getItem(\"theme\")")
  end
end
