require 'rails_helper'

RSpec.describe User, type: :model do
  fixtures :users
  let(:user) do
    User.new(username: 'Example User',
             email: 'user@example.com',
             password: 'GoodPassword1!',
             password_confirmation: 'GoodPassword1!')
  end
  let(:other_user) { users(:michael) }

  it 'is valid with valid arguments' do
    expect(user).to be_valid
  end

  it 'is invalid with an empty username' do
    user.username = '  '
    expect(user).not_to be_valid
  end

  it 'is invalid with not unique username' do
    user.username = other_user.username
    expect(user).not_to be_valid
  end

  it 'is invalid with empty email' do
    user.email = ' '
    expect(user).not_to be_valid
  end

  it 'is invalid with email with non-email format' do
    user.email = 'bad#email.com'
    expect(user).not_to be_valid
  end

  it 'is invalid with not unique email' do
    user.email = other_user.email
    expect(user).not_to be_valid
  end

  it 'is invalid with password < 6 characters' do
    user.password = 'bad'
    user.password_confirmation = 'bad'
    expect(user).not_to be_valid
  end

  it 'is invalid with password not matching password_confirmation' do
    user.password_confirmation = 'DifferentPassword'
    expect(user).not_to be_valid
  end
end
