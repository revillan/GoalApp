require 'spec_helper'
require 'rails_helper'

feature "the signup process" do

  scenario "has a new user page" do
    visit new_user_url
    expect(page).to have_content "Sign Up"
  end

  feature "signing up a user" do

    scenario "shows username on the homepage after signup" do
      visit new_user_url
      fill_in('Username', with: "Userman")
      fill_in('Password', with: "password")
      click_button('Sign up')

      visit user_url(User.last)

      expect(page).to have_content "Userman"
    end

  end

end

feature "logging in" do

  scenario "logging in" do
    User.create(username: "Userman", password: "password")
    visit new_session_url
    fill_in('Username', with: "Userman")
    fill_in('Password', with: "password")
    click_button('Sign in')

    visit user_url(User.last)
    expect(page).to have_content "Userman"
  end
end

feature "logging out" do

  scenario "begins with a logged out state" do
    User.create(username: "Userman", password: "password")
    visit new_session_url
    fill_in('Username', with: "Userman")
    fill_in('Password', with: "password")
    click_button('Sign in')
    click_link('Log Out')
    visit new_session_url
    expect(page).to_not have_content("Userman")
  end


end
