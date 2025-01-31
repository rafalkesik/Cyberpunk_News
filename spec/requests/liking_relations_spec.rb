require 'rails_helper'

RSpec.describe 'LikingRelations', type: :request do
  describe 'POST /liking_relations' do
    context 'when not logged in' do
      it 'does not like the post' do
        expect do
          post liking_relations_path, as: :turbo_stream
        end.to change(LikingRelation, :count).by(0)
      end

      it 'prompts the user to log-in' do
        post liking_relations_path, as: :turbo_stream
        assert_select 'div.alert-warning', 'You must be logged in to upvote.'
      end
    end

    context 'when logged in' do
      fixtures :users, :posts
      let(:user) { users(:admin) }
      let(:liked_post) { posts(:one) }

      def perform_post_request(post_id)
        post liking_relations_path,
             as: :turbo_stream,
             params: { liking_relation: { liked_post_id: post_id } }
      end

      before do
        login_as(user)
      end

      context 'when post does not exist (has been deleted just before liking)' do
        it 'does not like a post' do
          expect do
            perform_post_request(999)
          end.to change(LikingRelation, :count).by(0)
          assert_select 'div.alert-danger', (I18n.t 'flash.post_deleted')
        end
      end

      context 'when post exists' do
        it 'likes the post' do
          expect do
            perform_post_request(liked_post.id)
          end.to change(LikingRelation, :count).by(1)
        end

        it 'highlights upvote icon' do
          perform_post_request(liked_post.id)

          assert_select 'form[action=?]', liking_relations_path do |form|
            assert_select form, 'button>i.text-highlight'
            assert_select form, 'input[value=?]', user.id
            assert_select form, 'input[value=?]', liked_post.id
          end
        end

        it "increases post's points" do
          perform_post_request(liked_post.id)

          assert_select 'turbo-stream[target=?]', "post-#{liked_post.id}-points" do
            assert_select 'template', (I18n.t :points, count: liked_post.points)
          end
        end
      end
    end
  end

  describe 'DELETE /liking_relations/:id' do
    fixtures :liking_relations
    let(:relation) { liking_relations(:one_likes_two) }
    let(:liking_user) { relation.liking_user }
    let(:liked_post) { relation.liked_post }

    def perform_delete_request
      delete liking_relations_path,
             as: :turbo_stream,
             params: { liking_relation: { liked_post_id: liked_post.id } }
    end

    context 'when not logged in' do
      it 'does not unlike post' do
        expect do
          perform_delete_request
        end.to change(LikingRelation, :count).by(0)
      end

      it 'prompts user to log-in' do
        perform_delete_request
        assert_select 'div.alert-warning', 'You must be logged in to upvote.'
      end
    end

    context 'when logged in' do
      before do
        sign_in liking_user
      end

      it 'unlikes the post' do
        expect { perform_delete_request }.to change(LikingRelation, :count).by(-1)
      end

      it 'removes upvote icon highlight' do
        perform_delete_request

        assert_select 'form[action=?]', liking_relations_path do |form|
          assert_select form, 'input[value=?]', liking_user.id
          assert_select form, 'input[value=?]', liked_post.id
        end
      end

      it "decreases post's points" do
        perform_delete_request

        assert_select 'turbo-stream[target=?]', "post-#{liked_post.id}-points" do
          text = I18n.t :points, count: liked_post.points
          assert_select 'template', text
        end
      end
    end
  end
end
