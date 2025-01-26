require 'rails_helper'

RSpec.describe 'Users', type: :request do
  describe 'GET /users' do
    context 'when not logged in' do
      it 'redirects to login_url' do
        get users_path, as: :turbo_stream
        expect(response).to redirect_to(login_url)
        expect(response).to have_http_status(303)
        follow_redirect!
        assert_select 'div.alert', 'Please log in to view that page.'
      end
    end

    context 'when logged in' do
      fixtures :users

      context 'as normal user' do
        let(:user) { users(:michael) }

        before do
          login_as(user)
        end

        it 'renders template with all users' do
          get users_path, as: :turbo_stream
          expect(response).to render_template('users/index')
          User.all.each do |user|
            assert_select 'a[href=?]', user_path(user), user.username
            assert_select 'form[action=?]', user_path(user), count: 0
          end
        end
      end

      context 'as admin' do
        let(:admin) { users(:admin) }

        before do
          login_as(admin)
        end

        it 'renders tempalate with all users & delete buttons' do
          get users_path, as: :turbo_stream
          expect(response).to render_template('users/index')
          User.all.each do |user|
            assert_select 'a[href=?]', user_path(user), user.username
            assert_select 'form[action=?]', user_path(user) if !user.admin
          end
        end
      end
    end
  end

  describe 'GET /login' do
    it 'renders template with login & signup form' do
      get login_path, as: :turbo_stream
      assert_select 'h3', 'Sign up'
      assert_select 'form[action=?][method="post"]', users_path
    end
  end

  describe 'SHOW /users/:id' do
    fixtures :users
    let(:user) { users(:michael) }
    let(:other_user) { users(:dwight) }
    let(:admin) { users(:admin) }

    context 'when not logged in' do
      it 'redirects to login_url' do
        get user_path(other_user)
        expect(response).to redirect_to(login_url)
        expect(response).to have_http_status(303)
        follow_redirect!
        assert_select 'div.alert', (I18n.t 'flash.authenticate')
      end
    end

    context 'when logged in' do
      context 'as normal user' do
        before do
          login_as(user)
        end

        it 'shows a different user template' do
          get user_path(other_user), as: :turbo_stream
          expect(response).to render_template('users/show')
          assert_select 'h1', other_user.username
          assert_select 'form[action=?]', '/sessions', count: 0
          assert_select 'form[action=?]', "/users/#{other_user.id}", count: 0
          other_user.posts.each do |post|
            assert_select 'a', post.title
          end
        end

        it 'shows self-user template' do
          get user_path(user), as: :turbo_stream
          expect(response).to render_template('users/show')
          assert_select 'h1', user.username
          assert_select 'form[action=?]', '/en/sessions', count: 1
          assert_select 'form[action=?]', "/en/users/#{user.id}", count: 1
          user.posts.each do |post|
            assert_select 'a', post.title
          end
          assert_select 'input[type="submit"][value=?]',
                        'delete'
        end
      end

      context 'as admin' do
        before do
          login_as(admin)
        end

        it 'shows other user with posts delete buttons' do
          get user_path(other_user)
          other_user.posts.each do |post|
            assert_select 'form[action=?]', post_path(post) do
              assert_select 'input[type="submit"][value=?]', 'delete'
            end
          end
        end
      end
    end
  end

  describe 'POST /users' do
    it 'signs up and logs in with valid data' do
      expect do
        post users_path,
             as: :turbo_stream,
             params: { user: { username: 'valid_name',
                               password: 'password',
                               password_confirmation: 'password' } }
      end.to change(User, :count).by(1)

      expect(response).to redirect_to(User.last)
      expect(response).to have_http_status(303)
      follow_redirect!
      assert_select 'div.alert-success', 'New user created & logged in.'
    end

    it 'renders errors with invalid data' do
      expect do
        post users_path,
             as: :turbo_stream,
             params: { user: { username: 'michael',
                               password: 'password',
                               password_confirmation: 'password1' } }
      end.to change(User, :count).by(0)

      assert_select 'turbo-stream[action="update"][target=?]', 'new_user' do
        assert_select 'template' do
          assert_select '.alert.alert-danger', 'The form contains errors:'
        end
      end
    end
  end

  describe 'UPDATE /users/:id' do
    fixtures :users
    let(:user) { users(:michael) }
    let(:other_user) { users(:dwight) }

    context 'when logged in as a different user (security case)' do
      before do
        login_as(other_user)
      end

      it 'redirects to root_url' do
        patch user_path(user), as: :turbo_stream
        expect(response).to redirect_to(root_url)
        expect(response).to have_http_status(303)
      end
    end

    context 'when logged in as the updated user' do
      before do
        login_as(user)
      end

      it 'updates user with valid data' do
        patch user_path(user),
              as: :turbo_stream,
              params: { user: { username: user.username,
                                password: 'NewPass',
                                password_confirmation: 'NewPass' } }
        user.reload
        expect(user.authenticate('NewPass')).to be_truthy
        assert_select 'turbo-stream[target=?]', 'flash-messages' do
          assert_select 'template', 'Password updated.'
        end
      end

      it 'renders errors with invalid data' do
        get user_path(user)
        patch user_path(user),
              as: :turbo_stream,
              params: { user: { username: user.username,
                                password: 'NewPass',
                                password_confirmation: 'Invalid' } }
        user.reload
        expect(user.authenticate('NewPass')).to be false
        assert_select 'turbo-stream[target=?]', 'flash-messages' do
          assert_select 'template', "Passwords don't match."
        end
      end
    end
  end

  describe 'DELETE /users/:id' do
    fixtures :users
    let(:user) { users(:michael) }
    let(:admin) { users(:admin) }

    context 'when not logged in' do
      it 'redirects to login_url' do
        delete user_path(user)
        expect(response).to redirect_to(root_url)
      end
    end

    context 'when logged in as non-admin' do
      before do
        login_as(user)
      end

      it 'redirects to root_url' do
        delete user_path(user)
        expect(response).to redirect_to(root_url)
      end
    end

    context 'when logged in as admin' do
      before do
        login_as(admin)
      end

      it 'deletes the user and its posts' do
        expect do
          expect do
            delete user_path(user), as: :turbo_stream
          end.to change(Post, :count).by(-user.posts.count)
        end.to change(User, :count).by(-1)

        assert_select 'turbo-stream[action=replace][target=?]', 'flash-messages' do
          assert_select 'template',
                        "Successfully deleted user: #{user.username}."
        end
        assert_select 'turbo-stream[action=remove][target=?]',
                      "user-#{user.id}"
      end
    end
  end
end
