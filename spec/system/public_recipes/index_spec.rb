require 'rails_helper'

RSpec.describe 'Public Recipes #index', type: :system do
  subject do
    test_user = User.create(name: 'Tom', email: 'tom@example.com', password: 'password')
    Food.create(user: test_user, name: 'milk', measurement_unit: 'L', unit_price: 2)

    @user = User.create(name: 'Maria', email: 'maria@example.com', password: 'password')
    egg = Food.create(user: @user, name: 'egg', measurement_unit: 'units', unit_price: 10.5)
    flour = Food.create(user: @user, name: 'flour', measurement_unit: 'kg', unit_price: 11)

    public_recipe = Recipe.create(user: @user, name: 'public recipe', public: true, preparation_time: '2min',
                                  cooking_time: '5min', description: 'test')
    RecipeFood.create(quantity: 2, food: egg, recipe: public_recipe)
    RecipeFood.create(quantity: 1, food: flour, recipe: public_recipe)

    private_recipe = Recipe.create(user: @user, name: 'private recipe', preparation_time: '3min', cooking_time: '1min',
                                   description: 'test2')
    RecipeFood.create(quantity: 1, food: egg, recipe: private_recipe)

    Recipe.create(user: @user, name: 'public recipe 2', public: true, preparation_time: '2min', cooking_time: '5min',
                  description: 'test')

    visit new_user_session_path
    within('#new_user') do
      fill_in 'Email', with: 'maria@example.com'
      fill_in 'Password', with: 'password'
    end

    find_button('Log in').click
    public_recipe
  end

  it 'should not display a private recipe' do
    subject
    visit root_path
    expect(page).to_not have_content('private recipe')
  end

  it 'should display public recipe name, total price and total food items' do
    subject
    visit root_path
    expect(page).to have_content('public recipe')
    expect(page).to have_content('Total Price: $32.00')
    expect(page).to have_content('Total Food Items: 2')
  end

  it 'should display public recipe 2' do
    subject
    visit root_path
    expect(page).to have_content('public recipe 2')
    expect(page).to have_content('No ingredient added')
  end

  it 'should redirect to recipe details' do
    recipe_id = subject.id
    visit root_path
    click_link 'public recipe'
    expect(page).to have_current_path(public_recipe_path(recipe_id))
  end
end
