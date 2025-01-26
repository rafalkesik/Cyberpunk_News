require 'rails_helper'

RSpec.describe "Sessions", type: :request do
  describe 'GET /login' do
    it 'renders template with login & signup form' do
      get login_path, as: :turbo_stream

      expect(response).to render_template('sessions/login')
      assert_select 'h3', 'Login'
      assert_select 'form[action=?][method=?]', '/en/sessions', 'post'
    end
  end

  describe 'POST /sessions' do
    fixtures :users
    let(:user) { users(:michael) }

    it 'logs in with valid data' do
      post sessions_path,
           as: :turbo_stream,
           params: { user: { username: user.username,
                             password: 'pass',
                             password_confirmation: 'pass' } }

      expect(session[:user_id]).to equal(user.id)
      expect(response).to redirect_to user
      follow_redirect!
      assert_select 'div.alert-success', 'Logged in successfully.'
    end

    it 'renders flash with invalid data' do
      post sessions_path,
           as: :turbo_stream,
           params: { user: { username: user.username,
                             password: 'invalid',
                             password_confirmation: 'invalid' } }

      expect(session[:user_id]).to be_nil
      assert_select 'turbo-stream[action="update"][target=?]',
                    'flash-messages' do
        assert_select 'template', 'Username or password are incorrect. Try again.'
      end
    end
  end

  describe 'DELETE /sessions/:id' do
    fixtures :users
    let(:user) { users(:michael) }

    before do
      login_as(user)
    end

    it 'logs out' do
      delete sessions_path, as: :turbo_stream

      expect(session[:user_id]).to be_nil
      expect(response).to redirect_to(root_url)
      expect(response).to have_http_status(303)
      follow_redirect!
      assert_select 'div.alert-success', 'Logged out successfully.'
    end
  end
end
