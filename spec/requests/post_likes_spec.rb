require 'rails_helper'

RSpec.describe 'PostLikes', type: :request do
  describe 'POST /post_likes' do
    context 'when not logged in' do
      it 'does not like the post' do
        expect do
          post post_likes_path, as: :turbo_stream
        end.to change(PostLike, :count).by(0)
      end

      it 'prompts the user to log-in' do
        post post_likes_path, as: :turbo_stream
        expect(response.body).to include(
          (I18n.t 'flash.authenticate_like')
        )
      end
    end

    context 'when logged in' do
      fixtures :users, :posts
      let(:user) { users(:admin) }
      let(:liked_post) { posts(:one) }

      def perform_post_request(post_id)
        post post_likes_path,
             as: :turbo_stream,
             params: { post_like: { liked_post_id: post_id } }
      end

      before do
        sign_in user
      end

      context 'when post does not exist (has been deleted just before liking)' do
        it 'does not like a post' do
          expect do
            perform_post_request(999)
          end.to change(PostLike, :count).by(0)

          expect(response.body).to include(
            (I18n.t 'flash.post_deleted')
          )
        end
      end

      context 'when post exists' do
        it 'likes the post' do
          expect do
            perform_post_request(liked_post.id)
          end.to change(PostLike, :count).by(1)
        end

        it 'highlights like icon' do
          perform_post_request(liked_post.id)

          expect(response).to have_http_status(200)
          assert_select 'i.text-highlight'
        end

        it "updates post's points" do
          expect do
            perform_post_request(liked_post.id)
          end.to change(liked_post, :points).by(1)

          expect(response).to have_http_status(200)
          expect(response.body).to include(
            (I18n.t :points, count: liked_post.points)
          )
        end
      end
    end
  end

  describe 'DELETE /post_likes/:id' do
    fixtures :post_likes
    let(:relation) { post_likes(:one_likes_two) }
    let(:liking_user) { relation.liking_user }
    let(:liked_post) { relation.liked_post }

    def perform_delete_request
      delete post_likes_path,
             as: :turbo_stream,
             params: { post_like: { liked_post_id: liked_post.id } }
    end

    context 'when not logged in' do
      it 'does not unlike post' do
        expect do
          perform_delete_request
        end.to change(PostLike, :count).by(0)
      end

      it 'prompts user to log-in' do
        perform_delete_request
        expect(response.body).to include(
          (I18n.t 'flash.authenticate_like')
        )
      end
    end

    context 'when logged in' do
      before do
        sign_in liking_user
      end

      it 'unlikes the post' do
        expect { perform_delete_request }.to change(PostLike, :count).by(-1)
      end

      it 'removes like icon highlight' do
        perform_delete_request

        expect(response).to have_http_status(200)
        assert_select 'i.text-secondary'
      end

      it "updates post's points" do
        expect do
          perform_delete_request
        end.to change(liked_post, :points).by(-1)

        expect(response).to have_http_status(200)
        expect(response.body).to include(
          (I18n.t :points, count: liked_post.points)
        )
      end
    end
  end
end
