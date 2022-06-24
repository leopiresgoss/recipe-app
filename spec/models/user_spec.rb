require 'rails_helper'

RSpec.describe User, type: :model do
  subject { described_class.new(name: 'Jhon', email: 'test123@test.com', password: 'abc123') }

  it 'Should be valid with valid attributes' do
    expect(subject).to be_valid
  end

  it 'Should not be valid without a name' do
    subject.name = nil
    expect(subject).to_not be_valid
  end
end
