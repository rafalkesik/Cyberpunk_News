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

  it 'is valid when arguments are valid' do
    expect(user).to be_valid
  end

  it 'is invalid when username is empty' do
    user.username = '  '
    expect(user).not_to be_valid
  end

  it 'is invalid when username is not unique' do
    user.username = other_user.username
    expect(user).not_to be_valid
  end

  it 'is invalid when email is empty' do
    user.email = ' '
    expect(user).not_to be_valid
  end

  it 'is invalid when email is not unique' do
    user.email = other_user.email
    expect(user).not_to be_valid
  end

  it 'is invalid when email has not URL-friendly format' do
    user.email = 'bad#email.com'
    expect(user).not_to be_valid
  end

  it 'is invalid when password is < 6 characters' do
    user.password = 'bad'
    user.password_confirmation = 'bad'
    expect(user).not_to be_valid
  end

  it 'is invalid when password does not match password_confirmation' do
    user.password_confirmation = 'DifferentPassword'
    expect(user).not_to be_valid
  end
end
