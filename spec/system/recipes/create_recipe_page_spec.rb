require 'rails_helper'

RSpec.describe 'Create recipe page', type: :system do
  subject do
    @u = User.create(name: 'Maria', email: 'maria@example.com', password: 'password')

    visit recipes_path

    within('#new_user') do
      fill_in 'Email', with: 'maria@example.com'
      fill_in 'Password', with: 'password'
    end

    find_button('Log in').click
  end

  it 'I\'m not authorized to see the create recipe page if I\'m not signed-in' do
    visit new_recipe_path

    expect(page).to have_current_path(new_user_session_path)
    expect(page).to have_content('You need to sign in or sign up before continuing.')
  end

  it 'I should see the nav header, the title "Create new recipe" and a form' do
    subject
    visit new_recipe_path

    expect(page).to have_button('Sign Out')
    expect(page).to have_link('Foods')
    expect(page).to have_link('Recipes')
    expect(page).to have_link('My Profile')
    expect(page).to have_selector('[action="/recipes"]')
    expect(page).to have_content('Create new recipe')
  end

  it 'Should contain form fields for creating a recipe and a "Create Recipe" button' do
    subject
    visit new_recipe_path

    expect(page).to have_field('Name')
    expect(page).to have_field('Preparation time')
    expect(page).to have_field('Cooking time')
    expect(page).to have_field('Description')
    expect(page).to have_button('Create Recipe')
  end

  it 'Submiting the form without filling some fields shoud display detailed errors' do
    subject
    visit new_recipe_path

    within('form[action="/recipes"]') do
      fill_in 'Name', with: 'Rspec Recipe'
      fill_in 'Cooking time', with: '3 hours'
    end

    find_button('Create Recipe').click

    expect(page).to have_content('2 errors prohibited this recipe from being saved:')
    expect(page).to have_content('Preparation time can\'t be blank')
    expect(page).to have_content('Description can\'t be blank')
  end

  it 'Submiting the form without filling any fields shoud display detailed errors' do
    subject
    visit new_recipe_path

    find_button('Create Recipe').click

    expect(page).to have_content('4 errors prohibited this recipe from being saved:')
    expect(page).to have_content('Name can\'t be blank')
    expect(page).to have_content('Preparation time can\'t be blank')
    expect(page).to have_content('Cooking time can\'t be blank')
    expect(page).to have_content('Description can\'t be blank')
  end

  it 'Submiting the form with valid data should redirect to recipes list page with a success message' do
    subject
    visit new_recipe_path

    within('form[action="/recipes"]') do
      fill_in 'Name', with: 'Rspec Recipe'
      fill_in 'Preparation time', with: '3 hours'
      fill_in 'Cooking time', with: '2 hours'
      fill_in 'Description', with: 'Testing'
    end

    find_button('Create Recipe').click

    expect(page).to have_current_path(recipes_path)
    expect(page).to have_content('Recipe created successfully.')
  end
end
