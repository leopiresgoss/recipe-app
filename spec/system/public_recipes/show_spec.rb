require 'rails_helper'

RSpec.describe 'Public Recipes #show', type: :system do
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

    visit new_user_session_path
    within('#new_user') do
      fill_in 'Email', with: 'maria@example.com'
      fill_in 'Password', with: 'password'
    end

    find_button('Log in').click
    { public_recipe:, private_recipe: }
  end

  it 'should display public recipe details' do
    public_recipe = subject[:public_recipe]
    visit public_recipe_path(public_recipe.id)
    expect(page).to have_content('public recipe')
    expect(page).to have_content('Preparation time: 2min')
    expect(page).to have_content('Cooking time: 5min')
    expect(page).to have_content('Description: test')
  end

  it "should display recipe's egg" do
    public_recipe = subject[:public_recipe]
    visit public_recipe_path(public_recipe.id)
    expect(page).to have_content('egg')
    expect(page).to have_content('2units')
    expect(page).to have_content('$21.00')
  end

  it "should display recipe's flour" do
    public_recipe = subject[:public_recipe]
    visit public_recipe_path(public_recipe.id)
    expect(page).to have_content('flour')
    expect(page).to have_content('1kg')
    expect(page).to have_content('$11.00')
  end

  it 'should not render a private recipe' do
    public_recipe = subject[:private_recipe]
    visit public_recipe_path(public_recipe.id)
    expect(page).to have_current_path(root_path)
  end
end
