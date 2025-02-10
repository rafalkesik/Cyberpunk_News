require 'rails_helper'

RSpec.describe 'Sessions', type: :request do
  describe 'GET /login' do
    context 'when not logged in' do
      it 'renders login form' do
        get login_path, as: :turbo_stream

        expect(response).to render_template('devise/sessions/new')
        assert_select 'h2', (I18n.t 'login')
        assert_select 'form[action=?][method=post]', login_path
      end
    end

    context 'when logged in' do
      fixtures :users
      let(:user) { users(:michael) }

      before { sign_in user }

      it 'redirects to user profile' do
        get login_path, as: :turbo_stream

        expect(response).to redirect_to(user_path(user))
        follow_redirect!
        expect(response.body).to include(
          (I18n.t 'devise.failure.already_authenticated')
        )
      end
    end
  end

  describe 'POST /login' do
    fixtures :users
    let(:user) { users(:michael) }
    let(:valid_data) do
      { email: user.email,
        password: 'pass' }
    end
    let(:invalid_data) do
      { email: user.email,
        password: 'invalid' }
    end

    context 'when given valid data' do
      before do
        post login_path, as: :turbo_stream, params: { user: valid_data }
      end

      it 'logs in the right user' do
        expect(request.env['warden'].user(:user)).to eq(user)
      end

      it 'redirects to user profile' do
        expect(response).to redirect_to user
        follow_redirect!
        expect(response.body).to include(
          (I18n.t 'devise.sessions.signed_in')
        )
      end
    end

    context 'when given invalid data' do
      before do
        post login_path, as: :turbo_stream, params: { user: invalid_data }
      end

      it 'does not log in any user' do
        expect(session['warden.user.user.key']).to be_nil
        expect(response.body).to include('Invalid Email or password')
      end
    end
  end

  describe 'DELETE /sessions/:id' do
    fixtures :users
    let(:user) { users(:michael) }

    context 'when not logged in' do
      before do
        delete logout_path, as: :turbo_stream
      end

      it 'redirects to root' do
        expect(response).to redirect_to(root_url)
        expect(response).to have_http_status(303)
        follow_redirect!
        expect(response.body).to include((I18n.t 'devise.sessions.already_signed_out'))
      end
    end

    context 'when loged in' do
      before do
        sign_in user
        delete logout_path, as: :turbo_stream
      end

      it 'logs out' do
        expect(session['warden.user.user.key']).to be_nil
        expect(response).to redirect_to(root_url)
        expect(response).to have_http_status(303)
        follow_redirect!
        expect(response.body).to include(
          (I18n.t 'devise.sessions.signed_out')
        )
      end
    end
  end
end
