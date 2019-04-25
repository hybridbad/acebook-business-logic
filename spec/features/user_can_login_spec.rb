require 'rails_helper'

RSpec.feature 'Log in', type: :feature do
  scenario 'Signup form should have link to log in page' do
    visit '/'
    click_link("Click here to log in.")
    expect(page).to have_current_path("/login")
  end

  scenario 'Login page should have email address and password fields' do
    visit '/login'
    expect(page).to have_field("Email address")
    expect(page).to have_field("Password")
  end

  scenario 'Logging in succesfully takes you to the posts page' do
    visit '/'
    fill_in 'user[email_address]', with: 'myemail@gmail.com'
    fill_in 'user[password]', with: 'mypassword'
    click_button 'Sign up'

    # need to log out here...

    visit '/login'
    fill_in 'Email address', with: 'myemail@gmail.com'
    fill_in 'Password', with: 'mypassword'
    click_button 'Log in'

    expect(page).to have_current_path("/posts")
  end

  scenario 'Trying to log in with invalid credentials returns to the login page' do
    visit '/'
    fill_in 'user[email_address]', with: 'myemail@gmail.com'
    fill_in 'user[password]', with: 'mypassword'
    click_button 'Sign up'

    # need to log out here...

    visit '/login'
    fill_in 'Email address', with: 'my_wrong_email@gmail.com'
    fill_in 'Password', with: 'mypassword'
    click_button 'Log in'

    expect(page).to have_current_path("/login")
  end

end