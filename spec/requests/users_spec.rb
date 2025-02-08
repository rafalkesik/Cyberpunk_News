require 'rails_helper'

RSpec.describe 'Users', type: :request do
  describe 'GET /users' do
    context 'when not logged in' do
      it 'redirects to login_url' do
        get users_path, as: :turbo_stream
        expect(response).to redirect_to(login_url)
        expect(response).to have_http_status(302)
        follow_redirect!
        assert_select 'div.alert', 'You need to sign in or sign up before continuing.'
      end
    end

    context 'when logged in' do
      fixtures :users

      context 'as normal user' do
        let!(:user) { users(:michael) }

        before do
          sign_in user
        end

        it 'renders all users' do
          get users_path, as: :turbo_stream
          expect(response).to render_template('users/index')
          User.all.each do |user|
            assert_select 'a[href=?]', user_path(user), user.username
            assert_select 'form[action=?][method="delete"]', user_path(user), count: 0
          end
        end
      end

      context 'as admin' do
        let!(:admin) { users(:admin) }

        before do
          sign_in admin
        end

        it 'renders all users & delete buttons' do
          get users_path, as: :turbo_stream
          expect(response).to render_template('users/index')
          User.all.each do |user|
            assert_select 'a[href=?]', user_path(user), user.username
            next if user.admin

            assert_select 'form[action=?]', user_path(user) do
              assert_select 'input[value="delete"]'
            end
          end
        end
      end
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
        expect(response).to have_http_status(302)
        expect(response).to redirect_to(login_url)
        follow_redirect!
        assert_select 'div.alert', 'You need to sign in or sign up before continuing.'
      end
    end

    context 'when logged in' do
      before do
        sign_in user
      end

      context "when :id is user's own id" do
        it 'renders all user data and forms updating password, username and posts' do
          get user_path(user), as: :turbo_stream
          expect(response).to have_http_status(200)
          expect(response).to render_template('users/profile')
          expect(response.body).to include("e-mail: #{user.email}")
          assert_select 'h1', user.username
          assert_select 'form[action=?]', logout_path, count: 1
          assert_select 'form[action=?]', user_password_path, count: 1
          assert_select 'form[action=?]', user_registration_path, count: 1 do
            assert_select 'input[value=patch]'
          end

          user.posts.each do |post|
            assert_select 'a', post.title
          end
          assert_select 'input[type="submit"][value=?]',
                        'delete'
        end
      end

      context 'when :id is of another user' do
        it "renders user's username and posts" do
          get user_path(other_user), as: :turbo_stream
          expect(response).to have_http_status(200)
          expect(response).to render_template('users/show')
          expect(response.body).not_to include("e-mail: #{other_user.email}")
          assert_select 'h1', other_user.username
          assert_select 'form[action=?]', '/sessions', count: 0
          assert_select 'form[action=?]', "/users/#{other_user.id}", count: 0
          other_user.posts.each do |post|
            assert_select 'a', post.title
          end
        end

        context 'when logged in as admin' do
          before do
            sign_in admin
          end

          it "renders delete buttons by the user's posts" do
            get user_path(other_user)
            expect(response).to render_template('users/show')
            other_user.posts.each do |post|
              assert_select 'form[action=?]', post_path(post) do
                assert_select 'input[type="submit"][value=?]', 'delete'
              end
            end
          end
        end
      end
    end
  end

  describe 'DELETE /users/:id' do
    fixtures :users
    let(:user) { users(:michael) }
    let(:admin) { users(:admin) }
    let(:other_user) { users(:dwight) }

    context 'when not logged in' do
      it 'redirects to root_url' do
        delete user_path(user), as: :turbo_stream
        expect(response).to have_http_status(303)
        expect(response).to redirect_to(root_url)
      end
    end

    context 'when logged in as non-admin' do
      before do
        sign_in user
      end

      it 'redirects to root_url' do
        delete user_path(other_user), as: :turbo_stream
        expect(response).to have_http_status(303)
        expect(response).to redirect_to(root_url)
      end
    end

    context 'when logged in as admin' do
      before do
        sign_in admin
      end

      it 'deletes the user' do
        expect do
          delete user_path(user), as: :turbo_stream
        end.to change(User, :count).by(-1)

        assert_select 'turbo-stream[action=replace][target=?]', 'flash-messages' do
          assert_select 'template',
                        "Successfully deleted user: #{user.username}."
        end
        assert_select 'turbo-stream[action=remove][target=?]',
                      "user-#{user.id}"
      end

      it "deletes the user's posts" do
        expect do
          delete user_path(user), as: :turbo_stream
        end.to change(Post, :count).by(-user.posts.count)
      end
    end
  end
end
