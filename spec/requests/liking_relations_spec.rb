require 'rails_helper'

RSpec.describe 'LikingRelations', type: :request do
  describe 'POST /liking_relations' do
    context 'when not logged in' do
      it 'renders flash' do
        post liking_relations_path, as: :turbo_stream
        assert_select 'div.alert-warning', 'You must be logged in to upvote.'
      end
    end

    context 'when logged in' do
      fixtures :users, :posts
      let(:user) { users(:admin) }
      let(:liked_post) { posts(:one) }

      before do
        login_as(user)
      end

      it "highlights upvote icon and increases post's points" do
        # likes a post
        post liking_relations_path,
             as: :turbo_stream,
             params: { liking_relation: { liking_user_id: user.id,
                                          liked_post_id: liked_post.id } }
        # checks the like icon change
        assert_select 'form[action=?]', liking_relations_path do |form|
          assert_select form, 'button>i.text-highlight'
          assert_select form, 'input[value=?]', user.id
          assert_select form, 'input[value=?]', liked_post.id
        end
        # checks if the points changed
        assert_select 'turbo-stream[target=?]', "post-#{liked_post.id}-points" do
          assert_select 'template', (I18n.t :points, count: liked_post.points)
        end
      end
    end
  end

  describe 'DELETE /liking_relations/:id' do
    context 'when not logged in' do
      fixtures :liking_relations
      let(:relation) { liking_relations(:one_likes_two) }

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
