require 'rails_helper'

RSpec.describe User, type: :model do
  fixtures :users
  let(:user) do
    User.new(username: 'Example User',
             password: 'GoodPassword1!',
             password_confirmation: 'GoodPassword1!')
  end

  it 'is valid with valid arguments' do
    skip 'To be adjusted to Devise'
    expect(user).to be_valid
  end

  it 'is invalid with an empty username' do
    user.username = '  '
    expect(user).not_to be_valid
  end

  it 'is invalid with not unique username' do
    user.username = 'michael'
    expect(user).not_to be_valid
  end

  it 'is invalid with password not matching password_confirmation' do
    user.password_confirmation = 'DifferentPassword'
    expect(user).not_to be_valid
  end
end
