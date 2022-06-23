require 'rails_helper'

RSpec.describe Recipe, type: :model do
  subject do
    u = User.create(name: 'Jhon', email: 'test123@test.com', password: 'abc123')
    described_class.new(user: u, name: 'Test Recipe', preparation_time: '1h', cooking_time: '2h',
                        description: 'Testing')
  end

  it 'Should be valid with valid attributes' do
    expect(subject).to be_valid
  end

  it 'Should not be valid without a name' do
    subject.name = nil
    expect(subject).to_not be_valid
  end

  it 'Should not be valid without a preparation_time' do
    subject.preparation_time = nil
    expect(subject).to_not be_valid
  end

  it 'Should not be valid without a cooking_time' do
    subject.cooking_time = nil
    expect(subject).to_not be_valid
  end

  it 'Should not be valid without a description' do
    subject.description = nil
    expect(subject).to_not be_valid
  end

  it 'Should not be valid without a user association' do
    subject.user = nil
    expect(subject).to_not be_valid
  end

  it 'Should not be valid with a preparation_time length > 15' do
    subject.preparation_time = 'a' * 16
    expect(subject).to_not be_valid
  end

  it 'Should not be valid with a cooking_time length > 15' do
    subject.cooking_time = 'a' * 16
    expect(subject).to_not be_valid
  end

  it 'Should have a default value for public column' do
    expect(subject.public).to be_falsey
  end
end
