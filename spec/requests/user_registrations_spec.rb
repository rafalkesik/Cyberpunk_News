require 'rails_helper'

RSpec.describe 'UserRegistrations', type: :request do
  describe 'GET /sign_up' do
    it 'renders signup form' do
      get new_user_registration_path, as: :turbo_stream
      expect(response).to render_template('devise/registrations/new')
      assert_select 'h2', (I18n.t 'sign_up')
      assert_select 'form[action=?][method="post"]',
                    user_registration_path
    end
  end

  describe 'POST /users' do
    context 'when data is valid' do
      let(:data) do
        { username: 'valid_name',
          email: 'valid@email.com',
          password: 'password',
          password_confirmation: 'password' }
      end

      it 'signs up and logs in' do
        expect do
          post user_registration_path, as: :turbo_stream, params: { user: data }
        end.to change(User, :count).by(1)

        expect(response).to redirect_to(User.last)
        expect(response).to have_http_status(303)
        follow_redirect!
        expect(response.body).to include(
          (I18n.t 'devise.registrations.signed_up')
        )
      end
    end

    context 'when data is invalid' do
      let(:data) do
        { username: 'michael',
          email: 'michael#example.com',
          password: 'password',
          password_confirmation: 'password1' }
      end

      it 'does not sign up & renders errors' do
        expect do
          post user_registration_path, as: :turbo_stream, params: { user: data }
        end.to change(User, :count).by(0)

        expect(response.body).to include('The form contains errors:')
      end
    end
  end

  describe 'UPDATE /users/:id' do
    fixtures :users
    let(:user) { users(:michael) }
    let(:other_user) { users(:dwight) }

    before do
      sign_in user
    end

    context 'when given valid data' do
      let(:data) { { username: 'New Username' } }

      it 'updates username' do
        patch user_registration_path, as: :turbo_stream, params: { user: data }
        user.reload
        expect(user.username).to eq('New Username')
        follow_redirect!
        expect(response.body).to include(user.username)
        expect(response.body).to include('Your account has been updated successfully.')
      end
    end

    context 'when given invalid data' do
      let(:data) { { username: ' ' } }

      it 'does not update username' do
        patch user_registration_path, as: :turbo_stream, params: { user: data }
        user.reload
        expect(user.username).to eq('michael')
        expect(response.body).to include('The form contains errors:')
      end
    end
  end
end
