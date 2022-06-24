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

    @r = Recipe.create(user: @u, name: 'Test Recipe', preparation_time: '1h', cooking_time: '2h',
                       description: 'Testing')
  end

  it 'I\'m not authorized to see the recipes page if I\'m not signed-in' do
    r = Recipe.create(user: User.create(name: 'Maria', email: 'maria@example.com', password: 'password'),
                      name: 'Test Recipe', preparation_time: '1h', cooking_time: '2h', description: 'Testing')

    visit recipe_path r

    expect(page).to have_current_path(new_user_session_path)
    expect(page).to have_content('You need to sign in or sign up before continuing.')
  end

  it 'I should see the nav header,the recipe title and the recipe\'s details' do
    subject
    visit recipe_path @r

    expect(page).to have_button('Sign Out')
    expect(page).to have_link('Foods')
    expect(page).to have_link('Recipes')
    expect(page).to have_link('My Profile')
    expect(page).to have_content(@r.name)
    expect(page).to have_content(@r.preparation_time)
    expect(page).to have_content(@r.cooking_time)
    expect(page).to have_content(@r.description)
    expect(page).to have_content('Public')
    expect(page).to have_link('Generate shopping list')
    expect(page).to have_link('Add ingredient')
    expect(page).to have_content('Food')
    expect(page).to have_content('Quantity')
    expect(page).to have_content('Value')
    expect(page).to have_content('Actions')
  end

  it 'If there are no ingredients, should display "There are no ingredients yet."' do
    subject
    visit recipe_path @r

    expect(page).to have_content('There are no ingredients yet.')
  end

  it 'Clicking the Public toggle should set the recipe to "public"' do
    subject
    visit recipe_path @r

    find('.recipe-public-toggle').click

    expect(page).to have_selector('.on')
  end

  it 'Clicking the "Add ingredient" button should display a form for adding an ingredient with
     "Cancel" and "Save" button' do
    subject

    visit recipe_path @r

    find_link('Add ingredient').click

    expect(page).to have_content('Add ingredient')
    expect(page).to have_field('Food')
    expect(page).to have_field('Quantity')
    expect(page).to have_button('Add')
    expect(page).to have_link('Cancel')
    expect(page).to have_link('Create new food')
  end

  it 'Clicking the "Create new food" button should redirect to create food page' do
    subject

    visit recipe_path @r

    find_link('Add ingredient').click
    find_link('Create new food').click

    expect(page).to have_current_path(new_food_path)
  end

  it 'Clicking the "Cancel" button should close the Add ingredient form' do
    subject

    visit recipe_path @r

    find_link('Add ingredient').click
    find_link('Cancel').click

    expect(page).to_not have_selector('.add-ingredient-headline')
  end

  it 'Submitting the Add ingredient form with invalid data should display detailed errors' do
    subject

    visit recipe_path @r

    find_link('Add ingredient').click

    fill_in 'Quantity', with: 1

    expect(page).to_not have_content('2 errors prohibited this ingredient from being saved:')
  end

  it 'Submitting the Add ingredient form with valid data should display the item on the ingredients table' do
    subject
    Food.create(user: @u, name: 'Cookie', measurement_unit: 'gr', unit_price: 2)

    visit recipe_path @r

    find_link('Add ingredient').click

    select 'Cookie', from: 'Food'
    fill_in 'Quantity', with: 1
    find_button('Add').click

    expect(page).to have_content('Ingredient added.')
    expect(page).to have_content('Cookie')
    expect(page).to have_link('Modify')
    expect(page).to have_link('Remove')
  end

  it 'Clicking the "Remove" button for an ingredient shoould remove it from the table' do
    subject
    f = Food.create(user: @u, name: 'Cookie', measurement_unit: 'gr', unit_price: 2)
    RecipeFood.create(recipe: @r, food: f, quantity: 2)

    visit recipe_path @r

    within '.recipe-foods-table' do
      find_link('Remove').click
    end

    expect(page).to have_content('There are no ingredients yet.')
  end

  it 'Clicking the "Modify" button shoould remove render a form for editing the ingredient' do
    subject
    f = Food.create(user: @u, name: 'Cookie', measurement_unit: 'gr', unit_price: 2)
    RecipeFood.create(recipe: @r, food: f, quantity: 2)

    visit recipe_path @r

    within '.recipe-foods-table' do
      find_link('Modify').click
    end

    expect(page).to have_selector('input[type="number"]')
    expect(page).to have_button('Save')
    expect(page).to have_link('Cancel')
  end
end
