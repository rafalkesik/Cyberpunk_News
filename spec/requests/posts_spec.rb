require 'rails_helper'

RSpec.describe 'Posts', type: :request do
  describe 'GET /posts' do
    it 'renders all posts' do
      skip 'To be adjusted to Devise'
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
        login_as(admin)
      end

      it 'shows delete buttons for each post' do
        skip 'To be adjusted to Devise'
        get posts_path, as: :turbo_stream
        assert_select 'input[type="submit"][value="delete"]',
                      count: Post.count
      end
    end

    context 'when NOT logged in as admin' do
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

    it 'renders layout' do
      get post_path(showed_post), as: :turbo_stream

      expect(response).to render_template('posts/show')
      # checks rendering of post
      assert_select 'a[href=?]', post_path(showed_post), showed_post.title
      assert_select 'a[href=?]', post_path(showed_post),
                    "Comments: #{showed_post.comments.count}"
      assert_select 'a[href=?]', user_path(showed_post.user),
                    showed_post.user.username
      assert_select 'a[href=?]', showed_post.link,
                    "Read at: #{showed_post.short_link}"
      assert_select 'p', showed_post.content
      # checks if new post form is rendered
      assert_select 'form[action=?][method=?]',
                    '/en/comments', 'post'
      # checks if comments are rendered
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
        skip 'To be adjusted to Devise'
        get new_post_path, as: :turbo_stream
        expect(response).to redirect_to(login_url)
        expect(response).to have_http_status(303)
        follow_redirect!
        assert_select 'div.alert-warning', 'Log in to submit posts.'
      end
    end

    context 'when logged in' do
      fixtures :users
      let(:user) { users(:michael) }

      before do
        login_as(user)
      end

      it 'renders template' do
        skip 'To be adjusted to Devise'
        get new_post_path, as: :turbo_stream
        expect(response).to render_template('posts/new')
        assert_select 'form[action=?]', '/en/posts'
      end
    end
  end

  describe 'POST /posts' do
    context 'when not logged in' do
      it 'redirects to login_url' do
        skip 'To be adjusted to Devise'
        post posts_path, as: :turbo_stream
        expect(response).to redirect_to(login_url)
        expect(response).to have_http_status(303)
        follow_redirect!
        assert_select 'div.alert-warning', 'Log in to submit posts.'
      end
    end

    context 'when logged in' do
      fixtures :users
      let(:user) { users(:michael) }

      before do
        login_as(user)
      end

      it 'creates a valid post' do
        skip 'To be adjusted to Devise'
        expect do
          post posts_path,
               as: :turbo_stream,
               params: { post: { title: 'Valid title',
                                 content: 'Valid content',
                                 link: 'https://site.com/valid',
                                 points: 0,
                                 category_id: 2 } }
        end.to change(Post, :count).by(1)

        expect(response).to redirect_to(posts_path)
        expect(response).to have_http_status(303)
        follow_redirect!
        assert_select 'div.alert-success', 'News Post created!'
        # makes sure that the new post is listed at /posts
        assert_select 'a', 'Valid title'
      end

      it 'does not create invalid post' do
        skip 'To be adjusted to Devise'
        expect do
          post posts_path,
               as: :turbo_stream,
               params: { post: { title: '  ',
                                 content: '',
                                 link: '',
                                 points: 0 } }
        end.to change(Post, :count).by(0)

        assert_select 'div.error-explanation' do
          assert_select 'div.alert-danger',
                        'The form contains errors:'
        end
      end
    end
  end

  describe 'DELETE /posts/:id' do
    fixtures :posts
    let(:deleted_post) { posts(:one) }

    context 'when not logged in' do
      it 'redirects to login_url' do
        skip 'To be adjusted to Devise'
        delete post_path(deleted_post), as: :turbo_stream
        expect(response).to redirect_to(login_url)
        expect(response).to have_http_status(303)
        follow_redirect!
        assert_select 'div.alert-warning', 'Log in to submit posts.'
      end
    end

    context 'when logged in' do
      fixtures :users
      let(:other_user) { users(:dwight) }
      let(:author) { users(:michael) }
      let(:admin) { users(:admin) }

      context 'as non-admin & non-author' do
        before do
          login_as(other_user)
        end

        it 'redirects to root' do
          skip 'To be adjusted to Devise'
          delete post_path(deleted_post), as: :turbo_stream
          expect(response).to redirect_to(root_url)
          expect(response).to have_http_status(303)
        end
      end

      context 'as admin or author' do
        before do
          login_as(admin)
        end

        it 'deletes post' do
          skip 'To be adjusted to Devise'
          expect do
            delete post_path(deleted_post), as: :turbo_stream
          end.to change(Post, :count).by(-1)
          assert_select 'turbo-stream[target=?]', 'flash-messages' do
            assert_select 'template', 'Post deleted.'
          end
          assert_select 'turbo-stream[action="remove"][target=?]',
                        "post_#{deleted_post.id}"
        end

        context 'when in show_post view' do
          it 'deletes post & redirects to root' do
            skip 'To be adjusted to Devise'
            get post_path(deleted_post)
            delete post_path(deleted_post),
                   as: :turbo_stream,
                   headers: { 'HTTP_REFERER' => post_url(deleted_post) }
            expect(response).to redirect_to(root_url)
            expect(response).to have_http_status(303)
          end
        end
      end
    end
  end
end
