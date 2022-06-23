require 'rails_helper'

RSpec.describe RecipeFood, type: :model do
  subject do
    u = User.create(name: 'Jhon', email: 'test123@test.com', password: 'abc123')
    r = Recipe.create(user: u, name: 'Test Recipe', preparation_time: '1h', cooking_time: '2h',
                      description: 'Testing')
    f = Food.create(user: u, name: 'Rice', measurement_unit: 'kl', unit_price: 1.5)
    described_class.new(recipe: r, food: f, quantity: 2)
  end

  it 'Should be valid with valid attributes' do
    expect(subject).to be_valid
  end

  it 'Should not be valid without a quantity' do
    subject.quantity = nil
    expect(subject).to_not be_valid
  end

  it 'Should not be valid without a recipe association' do
    subject.recipe = nil
    expect(subject).to_not be_valid
  end

  it 'Should not be valid without a food association' do
    subject.food = nil
    expect(subject).to_not be_valid
  end

  it 'Should not be valid if quantity is less than 1' do
    subject.quantity = 0
    expect(subject).to_not be_valid
  end

  it 'Should not be valid if quantity is not an integer' do
    subject.quantity = '4asd'
    expect(subject).to_not be_valid
  end
end
