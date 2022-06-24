require 'rails_helper'

RSpec.describe 'Navbar', type: :system do
  subject do
    User.create(name: 'Tom', email: 'tom@example.com', password: 'password')

    visit new_user_session_path
    within('#new_user') do
      fill_in 'Email', with: 'tom@example.com'
      fill_in 'Password', with: 'password'
    end

    find_button('Log in').click
  end

  it 'should have a nav tag' do
    visit root_path
    expect(page).to have_selector('nav')
  end

  it 'should redirect to log in when clicking the logo' do
    visit root_path
    find('a[title="Home"]').click
    expect(page).to have_current_path(root_path)
  end

  context 'user is not logged' do
    it 'should display only sign in and sign out' do
      visit root_path
      expect(page).to have_link('Sign In')
      expect(page).to have_link('Sign Up')
      expect(page).to_not have_link('Foods')
      expect(page).to_not have_link('Recipes')
      expect(page).to_not have_link('My Profile')
      expect(page).to_not have_button('Sign out')
    end

    it 'should redirect to sign in when clicking sign in' do
      visit root_path
      click_link 'Sign In'
      expect(page).to have_current_path(new_user_session_path)
    end

    it 'should redirect to sign up when clicking sign up' do
      visit root_path
      click_link 'Sign Up'
      expect(page).to have_current_path(new_user_registration_path)
    end
  end

  context 'logged user' do
    it 'should display Foods, Recipes, My Profile, Sign Out' do
      subject
      visit root_path
      expect(page).to_not have_link('Sign In')
      expect(page).to_not have_link('Sign Up')
      expect(page).to have_link('Foods')
      expect(page).to have_link('Recipes')
      expect(page).to have_link('My Profile')
      expect(page).to have_button('Sign Out')
    end

    it 'should redirect to log in when clicking the logo' do
      subject
      visit foods_path
      find('a[title="Home"]').click
      expect(page).to have_current_path(root_path)
    end
  end

  context 'logged user nav-links' do
    it 'should redirect to Foods#index when clicking Foods' do
      subject
      visit root_path
      click_link 'Foods'
      expect(page).to have_current_path(foods_path)
    end

    it 'should redirect to Recipes#index when clicking Recipes' do
      subject
      visit root_path
      click_link 'Recipes'
      expect(page).to have_current_path(recipes_path)
    end

    it 'should redirect to Edit User Registration when clicking My Profile' do
      subject
      visit root_path
      click_link 'My Profile'
      expect(page).to have_current_path(edit_user_registration_path)
    end

    it 'should redirect to Homepage when clicking Sign Out' do
      subject
      visit root_path
      click_button 'Sign Out'
      expect(page).to have_current_path(root_path)
      expect(page).to have_content('Sign In')
      expect(page).to have_content('Sign Up')
    end
  end
end
