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

  scenario "If no search results are returned the user sees a message" do
    sign_up(username: "arthur", email: "user1@gmail.com")
    fill_in "user_search", with: "adasdasd"
    click_button "Go"
    expect(page).to have_content("No users found")
  end

  scenario "Search results that match a username will include the user" do
    sign_up(username: "arthur", email: "user1@gmail.com")
    sign_up(username: "bob", email: "user2@gmail.com")
    fill_in "user_search", with: "arthur"
    click_button "Go"
    expect(page).to have_content("arthur")
  end

  scenario "Search results that don't match a username will not include the user" do
    sign_up(username: "arthur", email: "user1@gmail.com")
    sign_up(username: "bob", email: "user2@gmail.com")
    fill_in "user_search", with: "adasdd"
    click_button "Go"
    expect(page).not_to have_content("arthur")
  end
end
