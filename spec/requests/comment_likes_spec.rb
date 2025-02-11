require 'rails_helper'

RSpec.describe 'CommentLikes', type: :request do
  describe 'POST /comment_likes' do
    context 'when not logged in' do
      it 'does not like the comment' do
        expect do
          post comment_likes_path, as: :turbo_stream
        end.to change(CommentLike, :count).by(0)
      end

      it 'prompts the user to log-in' do
        post comment_likes_path, as: :turbo_stream

        expect(response.body).to include(
          (I18n.t 'flash.authenticate_like')
        )
      end
    end

    context 'when logged in' do
      fixtures :users, :posts, :comments
      let(:user) { users(:michael) }
      let(:comment_post) { posts(:one) }
      let(:comment) { comments(:parent_of_three_and_four) }

      def perform_post_request(comment_id)
        post comment_likes_path,
             as: :turbo_stream,
             params: { comment_like: { liked_comment_id: comment_id } }
      end

      before do
        sign_in user
      end

      context 'when comment exists' do
        it 'likes the comment' do
          expect { perform_post_request(comment.id) }.to change(CommentLike, :count).by(1)
        end

        it 'highlights upvote icon' do
          perform_post_request(comment.id)

          assert_select 'i.text-highlight'
        end

        it "updates comment's points" do
          perform_post_request(comment.id)

          expect(response.body).to include(
            (I18n.t :points, count: comment.points)
          )
        end
      end

      context 'when comment does not exist (has been deleted just before liking)' do
        it 'does not like the comment' do
          expect do
            perform_post_request(999)
          end.to change(CommentLike, :count).by(0)

          expect(response.body).to include(
            (I18n.t 'flash.comment_deleted')
          )
        end
      end
    end
  end

  describe 'DELETE /comment_likes/:id' do
    context 'when not logged in' do
      fixtures :comment_likes
      let(:relation) { comment_likes(:one_likes_two) }

      it 'does not remove like' do
        expect do
          delete comment_like_path(relation), as: :turbo_stream
        end.to change(CommentLike, :count).by(0)
      end
    end

    context 'when logged in' do
      fixtures :comment_likes
      let(:relation) { comment_likes(:one_likes_two) }
      let(:user) { relation.liking_user }
      let(:liked_comment) { relation.liked_comment }

      def perform_delete_request
        delete comment_likes_path,
               as: :turbo_stream,
               params: { comment_like: { liked_comment_id: liked_comment.id } }
      end

      before do
        sign_in user
      end

      it 'removes like' do
        expect { perform_delete_request }.to change(
          CommentLike, :count
        ).by(-1)
      end

      it 'removes upvote icon highlight' do
        perform_delete_request

        assert_select 'i.text-secondary'
      end

      it "updates comment's points" do
        perform_delete_request

        expect(response.body).to include(
          (I18n.t :points, count: liked_comment.points)
        )
      end
    end
  end
end
