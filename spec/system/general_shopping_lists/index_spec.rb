require 'rails_helper'

RSpec.describe 'Public Recipes #index', type: :system do
  subject do
    test_user = User.create(name: 'Tom', email: 'tom@example.com', password: 'password')
    Food.create(user: test_user, name: 'test_user food not used', measurement_unit: 'L', unit_price: 2)
    corn = Food.create(user: test_user, name: 'corn', measurement_unit: 'kg', unit_price: 4)
    soda = Food.create(user: test_user, name: 'soda', measurement_unit: 'l', unit_price: 3)
    test_recipe = Recipe.create(user: test_user, name: 'test recipe', preparation_time: '3min', cooking_time: '1min',
                                description: 'test2')
    RecipeFood.create(quantity: 2, food: corn, recipe: test_recipe)
    RecipeFood.create(quantity: 3, food: soda, recipe: test_recipe)

    test_user_two = User.create(name: 'Lisa', email: 'lisa@example.com', password: 'password')
    Food.create(user: test_user_two, name: 'test_user_two food not used', measurement_unit: 'L', unit_price: 2)
    rice = Food.create(user: test_user_two, name: 'rice', measurement_unit: 'kg', unit_price: 3)
    milk = Food.create(user: test_user_two, name: 'milk', measurement_unit: 'l', unit_price: 1)
    test_recipe2 = Recipe.create(user: test_user_two, name: 'test recipe', preparation_time: '3min',
                                 cooking_time: '1min', description: 'test2')
    RecipeFood.create(quantity: 2, food: rice, recipe: test_recipe2)
    RecipeFood.create(quantity: 3, food: milk, recipe: test_recipe2)

    @user = User.create(name: 'Maria', email: 'maria@example.com', password: 'password')
    egg = Food.create(user: @user, name: 'egg', measurement_unit: 'units', unit_price: 10.5)
    user_recipe = Recipe.create(user: @user, name: 'public recipe', preparation_time: '2min',
                                cooking_time: '5min', description: 'test')
    RecipeFood.create(quantity: 2, food: egg, recipe: user_recipe)

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

  it "should not display foods from the current user and the ones that other users created but didn't used them" do
    subject
    visit general_shopping_lists_path

    expect(page).to_not have_content('egg')
    expect(page).to_not have_content('test_user food not used')
    expect(page).to_not have_content('test_user_two food not used')
  end

  it 'should display the correct amount of food items' do
    subject
    visit general_shopping_lists_path

    expect(page).to have_content('Amount of food items to buy: 4')
  end

  it 'should display the correct total price' do
    subject
    visit general_shopping_lists_path

    expect(page).to have_content('Total value of food needed: $26.00')
  end

  context 'corn' do
    it 'should be displayed its name, quantity and price' do
      subject
      visit general_shopping_lists_path

      expect(page).to have_content('corn 2kg $8.00')
    end
  end

  context 'soda' do
    it 'should be displayed its name, quantity and price' do
      subject
      visit general_shopping_lists_path

      expect(page).to have_content('soda 3l $9.00')
    end
  end

  context 'rice' do
    it 'should be displayed its name, quantity and price' do
      subject
      visit general_shopping_lists_path

      expect(page).to have_content('rice 2kg $6.00')
    end
  end

  context 'milk' do
    it 'should be displayed its name, quantity and price' do
      subject
      visit general_shopping_lists_path

      expect(page).to have_content('milk 3l $3.00')
    end
  end
end
