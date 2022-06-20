require 'rails_helper'

RSpec.describe Food, type: :model do
  subject do
    user = User.create(name: 'Jhon', email: 'test123@test.com', password: 'abc123')
    Food.new(name: 'Egg', measurement_unit: 'units', price: 10.5, user:)
  end

  before { subject.save }

  it 'Should be not validated without an user' do
    subject.user = nil
    expect(subject).to_not be_valid
  end

  it 'Should not be validated without a name' do
    subject.name = nil
    expect(subject).to_not be_valid
  end

  it 'Should not be validated without a price' do
    subject.price = nil
    expect(subject).to_not be_valid
  end

  it 'Should not be validated when price is not a decimal' do
    subject.price = 'test'
    expect(subject).to_not be_valid
  end

  it 'Should not be validated without a measurement_unit' do
    subject.measurement_unit = nil
    expect(subject).to_not be_valid
  end
end
