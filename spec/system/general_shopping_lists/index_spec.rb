require 'rails_helper'

RSpec.describe 'Public Recipes #index', type: :system do
  subject do
    test_user = User.create(name: 'Tom', email: 'tom@example.com', password: 'password')
    test_user_food = Food.create(user: test_user, name: 'test_user food', measurement_unit: 'L', unit_price: 2)
    test_recipe = Recipe.create(user: test_user, name: 'test recipe', preparation_time: '3min', cooking_time: '1min',
                                description: 'test2')
    RecipeFood.create(quantity: 2, food: test_user_food, recipe: test_recipe)

    @user = User.create(name: 'Maria', email: 'maria@example.com', password: 'password')

    egg = Food.create(user: @user, name: 'egg', measurement_unit: 'units', unit_price: 10.5)
    milk = Food.create(user: @user, name: 'milk', measurement_unit: 'L', unit_price: 5)
    Food.create(user: @user, name: 'food not used by user', measurement_unit: 'units', unit_price: 2)

    user_recipe1 = Recipe.create(user: @user, name: 'public recipe', preparation_time: '2min',
                                 cooking_time: '5min', description: 'test')
    RecipeFood.create(quantity: 3, food: egg, recipe: user_recipe1)
    RecipeFood.create(quantity: 3, food: milk, recipe: user_recipe1)

    user_recipe2 = Recipe.create(user: @user, name: 'public recipe', preparation_time: '2min',
                                 cooking_time: '5min', description: 'test')
    RecipeFood.create(quantity: 4, food: milk, recipe: user_recipe2)

    visit new_user_session_path
    within('#new_user') do
      fill_in 'Email', with: 'maria@example.com'
      fill_in 'Password', with: 'password'
    end

    find_button('Log in').click
  end

  it 'should display table columns' do
    subject
    visit general_shopping_lists_path

    expect(page).to have_content('Food')
    expect(page).to have_content('Quantity')
    expect(page).to have_content('Price')
  end

  it 'should not display foods from other users' do
    subject
    visit general_shopping_lists_path

    expect(page).to_not have_content('test_user food')
  end

  it 'should not display foods that have not been used' do
    subject
    visit general_shopping_lists_path

    expect(page).to_not have_content('food not used by user')
  end

  it 'should display the correct amount of food items' do
    subject
    visit general_shopping_lists_path

    expect(page).to have_content('Amount of food items to buy: 2')
  end

  it 'should display the correct total price' do
    subject
    visit general_shopping_lists_path

    expect(page).to have_content('Total value of food needed: $66.50')
  end

  context 'egg' do
    it 'should be displayed its name, quantity and price' do
      subject
      visit general_shopping_lists_path

      expect(page).to have_content('egg 3units $31.50')
    end
  end

  context 'milk' do
    it 'should be displayed its name, quantity and price' do
      subject
      visit general_shopping_lists_path

      expect(page).to have_content('milk 7L $35.00')
    end
  end
end
