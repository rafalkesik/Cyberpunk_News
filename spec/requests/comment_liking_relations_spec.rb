require 'rails_helper'

RSpec.describe 'CommentLikingRelations', type: :request do
  describe 'POST /comment_liking_relations' do
    context 'when not logged in' do
      it 'does not like the comment' do
        expect do
          post liking_relations_path, as: :turbo_stream
        end.to change(CommentLikingRelation, :count).by(0)
      end

      it 'prompts the user to log-in' do
        post liking_relations_path, as: :turbo_stream

        assert_select 'div.alert-warning', 'You must be logged in to upvote.'
      end
    end

    context 'when logged in' do
      fixtures :users, :posts, :comments
      let(:user) { users(:michael) }
      let(:comment_post) { posts(:one) }
      let(:comment) { comments(:parent_of_three_and_four) }

      def perform_post_request(comment_id)
        post comment_liking_relations_path,
             as: :turbo_stream,
             params: { comment_liking_relation: { liked_comment_id: comment_id } }
      end

      before do
        sign_in user
      end

      context 'when comment exists' do
        it 'likes the comment' do
          expect { perform_post_request(comment.id) }.to change(CommentLikingRelation, :count).by(1)
        end

        it 'highlights upvote icon' do
          perform_post_request(comment.id)

          assert_select 'turbo-stream[target=?]', "comment-#{comment.id}-upvote" do
            assert_select 'template',
                          partial: 'comments/comment_upvote_form',
                          comment: comment,
                          current_user: user
          end
        end

        it "updates comment's points" do
          perform_post_request(comment.id)

          assert_select 'turbo-stream[target=?]', "comment-#{comment.id}-points" do
            assert_select 'template', (I18n.t :points, count: comment.points)
          end
        end
      end

      context 'when comment does not exist (has been deleted just before liking)' do
        it 'does not like the comment' do
          expect do
            perform_post_request(999)
          end.to change(CommentLikingRelation, :count).by(0)

          assert_select 'div.alert-danger',
                        'The comment has been deleted.'
        end
      end
    end
  end

  describe 'DELETE /comment_liking_relations/:id' do
    context 'when not logged in' do
      fixtures :comment_liking_relations
      let(:relation) { comment_liking_relations(:one_likes_two) }

      it 'does not remove like' do
        expect do
          delete comment_liking_relation_path(relation), as: :turbo_stream
        end.to change(CommentLikingRelation, :count).by(0)
      end
    end

    context 'when logged in' do
      fixtures :comment_liking_relations
      let(:relation) { comment_liking_relations(:one_likes_two) }
      let(:user) { relation.liking_user }
      let(:liked_comment) { relation.liked_comment }

      def perform_delete_request
        delete comment_liking_relations_path,
               as: :turbo_stream,
               params: { comment_liking_relation: { liked_comment_id: liked_comment.id } }
      end

      before do
        sign_in user
      end

      it 'removes like' do
        expect { perform_delete_request }.to change(CommentLikingRelation, :count).by(-1)
      end

      it 'removes upvote icon highlight' do
        perform_delete_request

        assert_select 'form[action=?]', comment_liking_relations_path do |form|
          assert_select form, 'input[value=?]', liked_comment.id
        end
      end

      it "updates comment's points" do
        perform_delete_request

        assert_select 'turbo-stream[target=?]', "comment-#{liked_comment.id}-points" do
          text = I18n.t :points, count: liked_comment.points
          assert_select 'template', text
        end
      end
    end
  end
end
