require "rails_helper"

RSpec.feature "Search", type: :feature do
  scenario "A logged in user can see a search box" do
    sign_up
    expect(page).to have_field("user_search")
  end

  scenario "A logged out user cannot see a search box" do
    visit "/"
    expect(page).not_to have_field("user_search")
  end

  scenario "Submitting the search takes you to the results page" do
    sign_up
    fill_in "user_search", with: "arthur"
    click_button "Go"
    expect(page).to have_content("Search results")
  end
end
