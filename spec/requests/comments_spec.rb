require 'rails_helper'

RSpec.describe "Comments", type: :request do
  describe 'POST /comments' do
    fixtures :users, :posts
    let(:user) { users(:michael) }
    let(:comment_post) { posts(:one) }

    context 'when not logged in' do
      it 'does not create comment and shows flash' do
        expect do
          post comments_path, as: :turbo_stream
        end.to change(Comment, :count).by(0)
        assert_select 'div.alert-warning', 'Log in to submit comments.'
      end
    end

    context 'when logged in' do
      before do
        login_as(user)
      end

      it 'does not create comment with invalid data' do
        expect do
          post comments_path,
               as: :turbo_stream,
               params: { comment: { post_id: comment_post.id,
                                    user_id: user.id,
                                    content: '  ' } }
        end.to change(Comment, :count).by(0)
        assert_select 'div.alert-danger', 'Comment not valid.'
      end

      it 'creates a comment with valid data' do
        expect do
          post comments_path,
               as: :turbo_stream,
               params: { comment: { post_id: comment_post.id,
                                    user_id: user.id,
                                    content: 'Valid content.' } }
        end.to change(Comment, :count).by(1)
      end
    end
  end

  describe 'DELETE /comment/:id' do
    RSpec.shared_examples 'destroys comment and renders flash' do
      it 'destroys comment and renders flash' do
        expect do
          delete comment_path(comment), as: :turbo_stream
        end.to change(Comment, :count).by(-1)
        assert_select 'div.alert-success', 'The comment has been deleted.'
        assert_select 'turbo-stream[action="replace"][target=?]',
                      "comment-#{comment.id}"
      end
    end

    context 'which has no children' do
      fixtures :comments
      let(:comment) { comments(:parent_of_none) }

      context 'when logged in as author' do
        let(:author) { comment.user }

        before do
          login_as(author)
        end

        include_examples('destroys comment and renders flash')
      end

      context 'when logged in as admin' do
        fixtures :users
        let(:admin) { users(:admin) }

        before do
          login_as(admin)
        end

        include_examples('destroys comment and renders flash')
      end
    end

    context 'which has children' do
      fixtures :comments
      let(:comment) { comments(:parent_of_three_and_four) }
      let(:child_one) { comment.subcomments.first }
      let(:child_two) { comment.subcomments.last }
      let(:author) { comment.user }

      before do
        login_as(author)
      end

      it 'hides the comment and does not delete it until its children are deleted' do
        expect do
          delete comment_path(comment), as: :turbo_stream
        end.to change(Comment, :count).by(0)
        comment.reload
        expect(comment.hidden).to be true

        expect do
          delete comment_path(child_one), as: :turbo_stream
        end.to change(Comment, :count).by(-1)
        expect do
          delete comment_path(child_two), as: :turbo_stream
        end.to change(Comment, :count).by(-2)
      end
    end

    context 'when not logged in' do
      it 'does not delete comment and renders flash' do
        expect do
          delete comment_path(1), as: :turbo_stream
        end.to change(Comment, :count).by(0)
        assert_select 'div.alert-warning', 'Log in to submit comments.'
      end
    end

    context 'when logged in as non-admin and non-author' do
      fixtures :users
      let(:user) { users(:michael) }

      before do
        login_as(user)
      end

      it 'does not delete comment and redirects to root' do
        expect do
          delete comment_path(1), as: :turbo_stream
        end.to change(Comment, :count).by(0)
        expect(response).to redirect_to(root_url)
        expect(response).to have_http_status(303)
      end
    end
  end
end
