require 'rails_helper'

RSpec.describe 'CommentLikingRelations', type: :request do
  describe 'POST /comment_liking_relations' do
    context 'when not logged in' do
      it 'renders flash' do
        post liking_relations_path, as: :turbo_stream
        assert_select 'div.alert-warning', 'You must be logged in to upvote.'
      end
    end

    context 'when logged in' do
      fixtures :users, :posts, :comments
      let(:user) { users(:michael) }
      let(:comment_post) { posts(:one) }
      let(:comment) { comments(:parent_of_three_and_four) }

      before do
        login_as(user)
      end

      context 'when comment exists' do
        it "highlights upvote icon and increases comment's points" do
          # likes a comment
          post comment_liking_relations_path,
               as: :turbo_stream,
               params: { comment_liking_relation: { liked_comment_id: comment.id } }
          # checks the like icon change
          assert_select 'turbo-stream[target=?]', "comment-#{comment.id}-upvote" do
            assert_select 'template',
                          partial: 'comments/comment_upvote_form',
                          comment: comment,
                          current_user: user
          end
          # checks if the points changed
          assert_select 'turbo-stream[target=?]', "comment-#{comment.id}-points" do
            assert_select 'template', (I18n.t :points, count: comment.points)
          end
        end
      end

      context 'when comment does not exist (has just been deleted)' do
        it 'renders flash' do
          post comment_liking_relations_path,
               as: :turbo_stream,
               params: { comment_liking_relation: { liked_comment_id: 999 } }
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

      it 'renders flash' do
        delete liking_relation_path(relation), as: :turbo_stream
        assert_select 'div.alert-warning', 'You must be logged in to upvote.'
      end
    end

    context 'when logged in' do
      fixtures :liking_relations
      let(:relation) { liking_relations(:one_likes_two) }
      let(:user) { relation.liking_user }
      let(:liked_post) { relation.liked_post }

      before do
        login_as(user)
      end

      it "removes upvote icon highlight and decreases post's points" do
        delete liking_relations_path,
               as: :turbo_stream,
               params: { liking_relation: { liked_post_id: liked_post.id } }
        # checks like icon change
        assert_select 'form[action=?]', liking_relations_path do |form|
          assert_select form, 'input[value=?]', user.id
          assert_select form, 'input[value=?]', liked_post.id
        end
        # checks if the points changed
        assert_select 'turbo-stream[target=?]', "post-#{liked_post.id}-points" do
          text = I18n.t :points, count: liked_post.points
          assert_select 'template', text
        end
      end
    end
  end
end
