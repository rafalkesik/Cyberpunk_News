require 'rails_helper'

RSpec.describe 'Posts', type: :request do
  describe 'GET /posts' do
    it 'renders all posts' do
      get posts_path, as: :turbo_stream
      Post.all.each do |post|
        assert_select 'a[href=?]', post_path(post), post.title
        assert_select 'a[href=?]', post_path(post),
                      "Comments: #{post.comments.count}"
        assert_select 'a[href=?]', user_path(post.user), post.user.username
        assert_select 'a[href=?]', post.link, "Read at: #{post.short_link}"
      end
    end

    context 'when logged in as admin' do
      fixtures :users
      let(:admin) { users(:admin) }

      before do
        sign_in admin
      end

      it 'shows delete buttons for each post' do
        get posts_path, as: :turbo_stream
        assert_select 'input[type="submit"][value="delete"]',
                      count: Post.count
      end
    end

    context 'when not logged in as admin' do
      it 'does not show delete buttons' do
        get posts_path, as: :turbo_stream
        assert_select 'input[type="submit"][value="delete"]',
                      count: 0
      end
    end
  end

  describe 'SHOW /posts/:id' do
    fixtures :posts
    let(:showed_post) { posts(:one) }
    let(:comments) { showed_post.comments }

    it 'renders all elements of the post' do
      get post_path(showed_post), as: :turbo_stream

      expect(response).to render_template('posts/show')
      assert_select 'a[href=?]', post_path(showed_post), showed_post.title
      assert_select 'a[href=?]', post_path(showed_post),
                    "Comments: #{showed_post.comments.count}"
      assert_select 'a[href=?]', user_path(showed_post.user),
                    showed_post.user.username
      assert_select 'a[href=?]', showed_post.link,
                    "Read at: #{showed_post.short_link}"
      assert_select 'p', showed_post.content
    end

    it 'renders a new comment form' do
      get post_path(showed_post), as: :turbo_stream

      assert_select 'form[action=?][method=?]',
                    '/en/comments', 'post'
    end

    it 'renders all comments under this post' do
      get post_path(showed_post), as: :turbo_stream

      assert_select 'ul' do
        comments.each do |comment|
          assert_select 'li[id=?]', "comment-#{comment.id}" do
            assert_select 'div.comment-text', comment.content
          end
        end
      end
    end
  end

  describe 'NEW /posts' do
    context 'when not logged in' do
      it 'redirects to login_path' do
        get new_post_path, as: :turbo_stream

        expect(response).to redirect_to(login_url)
        expect(response).to have_http_status(302)
        follow_redirect!
        assert_select 'div.alert-alert', 'You need to sign in or sign up before continuing.'
      end
    end

    context 'when logged in' do
      fixtures :users
      let(:user) { users(:michael) }

      before do
        sign_in user
      end

      it 'renders new post form' do
        get new_post_path, as: :turbo_stream

        expect(response).to render_template('posts/new')
        assert_select 'form[action=?]', '/en/posts'
      end
    end
  end

  describe 'POST /posts' do
    context 'when not logged in' do
      it 'redirects to login_url' do
        post posts_path, as: :turbo_stream

        expect(response).to redirect_to(login_url)
        expect(response).to have_http_status(302)
        follow_redirect!
        assert_select 'div.alert-alert', 'You need to sign in or sign up before continuing.'
      end
    end

    context 'when logged in' do
      fixtures :users
      let(:user) { users(:michael) }
      let(:valid_data) do
        { title: 'Valid title',
          content: 'Valid content',
          link: 'https://site.com/valid',
          points: 0,
          category_id: 2 }
      end
      let(:invalid_data) do
        { title: '  ',
          content: '',
          link: '',
          points: 0 }
      end

      def perform_post_request(data)
        post posts_path, as: :turbo_stream, params: { post: data }
      end

      before do
        sign_in user
      end

      context 'when provided with valid data' do
        it 'creates post' do
          expect do
            perform_post_request(valid_data)
          end.to change(Post, :count).by(1)
        end

        it 'redirects to root' do
          perform_post_request(valid_data)

          expect(response).to redirect_to(posts_path)
          expect(response).to have_http_status(303)
          follow_redirect!
          assert_select 'div.alert-success', (I18n.t 'flash.post_created')
        end
      end

      context 'when provided with invalid data' do
        it 'does not create post' do
          expect do
            perform_post_request(invalid_data)
          end.to change(Post, :count).by(0)

          assert_select 'div.error-explanation' do
            assert_select 'div.alert-danger',
                          'The form contains errors:'
          end
        end
      end
    end
  end

  describe 'DELETE /posts/:id' do
    fixtures :posts
    let(:deleted_post) { posts(:one) }

    def perform_delete_request
      delete post_path(deleted_post), as: :turbo_stream
    end

    context 'when not logged in' do
      it 'redirects to login_url' do
        perform_delete_request

        expect(response).to redirect_to(login_url)
        expect(response).to have_http_status(302)
        follow_redirect!
        assert_select 'div.alert-alert', 'You need to sign in or sign up before continuing.'
      end
    end

    context 'when logged in' do
      fixtures :users
      let(:other_user) { users(:dwight) }
      let(:author) { users(:michael) }
      let(:admin) { users(:admin) }

      context 'as non-admin & non-author' do
        before do
          sign_in other_user
        end

        it 'redirects to root' do
          perform_delete_request

          expect(response).to redirect_to(root_url)
          expect(response).to have_http_status(303)
        end
      end

      context 'as admin or author' do
        let(:comments_count) { deleted_post.comments.count }

        before do
          sign_in admin
        end

        it 'deletes post and its comments' do
          expect do
            expect do
              perform_delete_request
            end.to change(Post, :count).by(-1)
          end.to change(Comment, :count).by(-comments_count)

          assert_select 'turbo-stream[target=?]', 'flash-messages' do
            assert_select 'template', 'Post deleted.'
          end
        end

        context 'when in show_post view' do
          it 'redirects to root' do
            get post_path(deleted_post)
            delete post_path(deleted_post),
                   as: :turbo_stream,
                   headers: { 'HTTP_REFERER' => post_url(deleted_post) }
            expect(response).to redirect_to(root_url)
            expect(response).to have_http_status(303)
          end
        end

        context 'when in other views than show_post' do
          it 'removes post from rendered list' do
            perform_delete_request

            assert_select 'turbo-stream[action="remove"][target=?]',
                          "post_#{deleted_post.id}"
          end
        end
      end
    end
  end
end
