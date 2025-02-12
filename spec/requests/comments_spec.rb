require 'rails_helper'

RSpec.describe 'Comments', type: :request do
  describe 'POST /comments' do
    fixtures :users, :posts
    let(:user) { users(:michael) }
    let(:comment_post) { posts(:one) }

    context 'when not logged in' do
      it 'does not create comment' do
        expect do
          post comments_path, as: :turbo_stream
        end.to change(Comment, :count).by(0)
      end

      it 'prompts the user to log-in' do
        post comments_path, as: :turbo_stream

        expect(response.body).to include(
          (I18n.t 'flash.authenticate_add_com')
        )
      end
    end

    context 'when logged in' do
      before do
        sign_in user
      end

      context 'when data is invalid' do
        let(:invalid_data) do
          { post_id: comment_post.id,
            user_id: user.id,
            content: '  ' }
        end

        it 'does not create comment' do
          expect do
            post comments_path, as: :turbo_stream, params: { comment: invalid_data }
          end.to change(Comment, :count).by(0)

          expect(response.body).to include(
            (I18n.t 'flash.comment_not_valid')
          )
        end
      end

      context 'when data is valid' do
        let(:valid_data) do
          { post_id: comment_post.id,
            user_id: user.id,
            content: 'Valid content.' }
        end

        it 'creates a comment' do
          expect do
            post comments_path, as: :turbo_stream, params: { comment: valid_data }
          end.to change(Comment, :count).by(1)
        end
      end
    end
  end

  describe 'DELETE /comment/:id' do
    context 'when not logged in' do
      fixtures :comments
      let(:comment) { comments(:parent_of_none) }

      it 'does not delete comment' do
        expect do
          delete comment_path(comment), as: :turbo_stream
        end.to change(Comment, :count).by(0)
      end

      it 'prompts the user to log-in' do
        delete comment_path(comment), as: :turbo_stream
        expect(response.body).to include(
          (I18n.t 'flash.authenticate_add_com')
        )
      end
    end

    context 'when logged in as non-admin and non-author' do
      fixtures :users, :comments
      let(:user) { users(:michael) }
      let(:comment) { comments(:parent_of_none) }

      before do
        sign_in user
      end

      it 'does not delete comment' do
        expect do
          delete comment_path(comment), as: :turbo_stream
        end.to change(Comment, :count).by(0)
      end

      it 'redirects to root' do
        delete comment_path(comment), as: :turbo_stream

        expect(response).to redirect_to(root_url)
        expect(response).to have_http_status(303)
      end
    end

    context 'when logged in as author or admin' do
      fixtures :users, :comments
      let(:parent)    { comments(:parent_of_three_and_four) }
      let(:child_one) { comments(:child_of_one) }
      let(:child_two) { comments(:second_child_of_one) }
      let(:admin)     { users(:admin) }
      let(:author)    { child_one.user }

      context 'when comment has children' do
        before do
          sign_in admin
        end

        it 'does not destroy the comment' do
          expect do
            delete comment_path(parent), as: :turbo_stream
          end.to change(Comment, :count).by(0)
        end

        it 'hides the comment' do
          delete comment_path(parent), as: :turbo_stream
          parent.reload
          expect(parent.hidden).to be true
        end
      end

      context 'when comment has no children' do
        it 'destroys comment' do
          sign_in author
          expect do
            delete comment_path(child_one), as: :turbo_stream
          end.to change(Comment, :count).by(-1)

          sign_in admin
          expect do
            delete comment_path(child_two), as: :turbo_stream
          end.to change(Comment, :count).by(-1)

          expect(response.body).to include(
            (I18n.t 'flash.comment_deleted')
          )
          assert_select 'turbo-stream[action="replace"][target=?]',
                        "comment-#{child_two.id}"
        end

        context 'when comment is also the last child of a hidden parent' do
          before do
            parent.update(hidden: true)
            sign_in admin
            delete comment_path(child_two), as: :turbo_stream
          end

          it "destroys comment's hidden parent" do
            expect do
              delete comment_path(child_one), as: :turbo_stream
            end.to change(Comment, :count).by(-2)
            expect(Comment.exists?(parent.id)).to be false
          end
        end
      end
    end
  end
end
