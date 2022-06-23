require 'rails_helper'

RSpec.describe 'Recipes list page', type: :system do
  subject do
    @u = User.create(name: 'Maria', email: 'maria@example.com', password: 'password')

    visit recipes_path

    within('#new_user') do
      fill_in 'Email', with: 'maria@example.com'
      fill_in 'Password', with: 'password'
    end

    find_button('Log in').click
  end

  it 'I\'m not authorized to see the recipes page if I\'m not signed-in' do
    visit recipes_path

    expect(page).to have_current_path(new_user_session_path)
    expect(page).to have_content('You need to sign in or sign up before continuing.')
  end

  it 'I should see the nav header,the title "My Recipes" and the "Create new recipe" button' do
    subject
    visit recipes_path

    expect(page).to have_button('Sign Out')
    expect(page).to have_link('Foods')
    expect(page).to have_link('Recipes')
    expect(page).to have_link('My Profile')
    expect(page).to have_link('Create new recipe')
    expect(page).to have_content('My Recipes')
  end

  it 'If there are no recipes, should display "There are no recipes yet."' do
    subject
    visit recipes_path

    expect(page).to have_content('There are no recipes yet.')
  end

  it 'I can see a recipes list and in each recipe item should be visible the name, description and a remove button' do
    subject
    Recipe.create(user: @u, name: 'Test Recipe', preparation_time: '1h', cooking_time: '2h',
                  description: 'Testing')

    visit recipes_path

    expect(page).to have_link('Test Recipe')
    expect(page).to have_content('Testing')
    expect(page).to have_button('REMOVE')
  end

  it 'Clicking the REMOVE button should remove the recipe from the list' do
    subject
    Recipe.create(user: @u, name: 'Test Recipe', preparation_time: '1h', cooking_time: '2h',
                  description: 'Testing')

    visit recipes_path

    find_button('REMOVE').click

    expect(page).to have_content('There are no recipes yet.')
  end

  it 'Clicking the recipe title link should redirect to the recipe details page' do
    subject
    r = Recipe.create(user: @u, name: 'Test Recipe', preparation_time: '1h', cooking_time: '2h',
                      description: 'Testing')

    visit recipes_path

    find_link('Test Recipe').click

    expect(page).to have_current_path(recipe_path(r))
  end

  it 'Clicking the "Create new recipe" link should redirect to the create recipe page' do
    subject
    Recipe.create(user: @u, name: 'Test Recipe', preparation_time: '1h', cooking_time: '2h',
                  description: 'Testing')

    visit recipes_path

    find_link('Create new recipe').click

    expect(page).to have_current_path(new_recipe_path)
  end
end
