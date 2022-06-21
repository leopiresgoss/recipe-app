require 'rails_helper'

RSpec.describe 'Foods New page', type: :system do
  subject do
    User.create(name: 'Maria', email: 'maria@example.com', password: 'password')

    visit new_user_session_path
    within('#new_user') do
      fill_in 'Email', with: 'maria@example.com'
      fill_in 'Password', with: 'password'
    end

    find_button('Log in').click
  end

  it 'should visit signin when user is not logged' do
    visit new_food_path
    expect(page).to have_current_path(new_user_session_path)
    expect(page).to have_content('You need to sign in or sign up before continuing')
  end

  it 'should contain name text input and its label' do
    subject
    visit new_food_path
    expect(page).to have_content('Name')
    expect(page).to have_selector('input[type="text"]#food_name')
  end

  it 'should contain name text input and its label' do
    subject
    visit new_food_path
    expect(page).to have_content('Name')
    expect(page).to have_selector('input[type="text"]#food_name')
  end

  it 'should contain mesurement unit text input and its label' do
    subject
    visit new_food_path
    expect(page).to have_content('Measurement unit')
    expect(page).to have_selector('input[type="text"]#food_measurement_unit')
  end

  it 'should contain name text input and its label' do
    subject
    visit new_food_path
    expect(page).to have_content('Unit price')
    expect(page).to have_selector('input[type="number"]#food_unit_price')
  end

  it 'should not submit it when name is not filled' do
    subject
    visit new_food_path
    fill_in 'Measurement unit', with: 'units'
    fill_in 'Unit price', with: '10.50'
    click_button 'Submit'
    expect(page).to have_current_path(new_food_path)
  end

  it 'should not submit it when Measurement unit is not filled' do
    subject
    visit new_food_path
    fill_in 'Name', with: 'Egg'
    fill_in 'Unit price', with: '10.50'
    click_button 'Submit'
    expect(page).to have_current_path(new_food_path)
  end

  it 'should not submit it when unit_price is not filled' do
    subject
    visit new_food_path
    fill_in 'Name', with: 'Egg'
    fill_in 'Measurement unit', with: 'units'
    click_button 'Submit'
    expect(page).to have_current_path(new_food_path)
  end

  it 'should submit when all fields are filled' do
    subject
    visit new_food_path
    fill_in 'Name', with: 'Egg'
    fill_in 'Measurement unit', with: 'units'
    fill_in 'Unit price', with: '10.50'
    click_button 'Submit'
    expect(page).to have_current_path(foods_path)
  end
end
