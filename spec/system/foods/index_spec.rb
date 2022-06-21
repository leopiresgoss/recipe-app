require 'rails_helper'

RSpec.describe 'Foods Index page', type: :system do
  subject do
    test_user = User.create(name: 'Tom', email: 'tom@example.com', password: 'password')
    Food.create(user: test_user, name: 'milk', measurement_unit: 'L', price: 2)

    @user = User.create(name: 'Maria', email: 'maria@example.com', password: 'password')
    Food.create(user: @user, name: 'egg', measurement_unit: 'units', price: 10.5)
    Food.create(user: @user, name: 'flour', measurement_unit: 'kg', price: 11)

    visit new_user_session_path
    within('#new_user') do
      fill_in 'Email', with: 'maria@example.com'
      fill_in 'Password', with: 'password'
    end

    find_button('Log in').click
  end

  it 'should visit signin when user is not logged' do
    visit foods_path
    expect(page).to have_current_path(new_user_session_path)
    expect(page).to have_content('You need to sign in or sign up before continuing')
  end

  it "should have foods' names, measurement_unit and price" do
    subject
    visit foods_path
    expect(page).to have_content('egg')
    expect(page).to have_content('flour')
    expect(page).to have_content('units')
    expect(page).to have_content('$10.50')
    expect(page).to have_content('$11.00')
  end

  it 'should not have food from a different user' do
    subject
    visit foods_path
    expect(page).to_not have_content('milk')
  end

  it 'should have Delete Button' do
    subject
    visit foods_path
    expect(page).to have_button('Delete')
  end

  it 'should delete the first food when clicking the first Delete button' do
    subject
    visit foods_path
    first(:button, 'Delete').click
    expect(page).to_not have_content('egg')
    expect(page).to have_content('flour')
  end

  it 'should have Add New Food Button' do
    subject
    visit foods_path
    expect(page).to have_link('Add New Food')
  end

  it 'should visit food form when clicking Add New Food Button' do
    subject
    visit foods_path
    find_link('Add New Food').click
    expect(page).to have_current_path(new_food_path)
  end
end
