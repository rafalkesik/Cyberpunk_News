require 'test_helper'

class LikingRelationsNotLoggedIn < ActionDispatch::IntegrationTest

  def setup
    @relation = liking_relations(:one_likes_two)
  end
end

class LikingRelationsNotLoggedInTest < LikingRelationsNotLoggedIn

  test 'should flash warning on create if not logged in' do
    post liking_relations_path, as: :turbo_stream
    assert_select 'turbo-stream[target=?]', 'flash-messages' do
      assert_select 'template', partial: 'layouts/flash'
    end
    assert_select 'div.alert-warning', 'You must be logged in to upvote.'
  end

  test 'should flash warning on destroy if not logged in' do
    delete liking_relations_path, as: :turbo_stream
    assert_select 'turbo-stream[target=?]', 'flash-messages' do
      assert_select 'template', partial: 'layouts/flash'
    end
    assert_select 'div.alert-warning', 'You must be logged in to upvote.'
  end
end

class LikingRelationsLoggedInTest < LikingRelationsNotLoggedIn

  def setup
    super
    @user = users(:michael)
    @other_user = users(:dwight)
    @post = posts(:two)
    login_as(@other_user)
  end

  test 'should redirect destroy if not the right user' do
    delete liking_relations_path,
           as: :turbo_stream,
           params: { liking_relation: { liking_user_id: @user.id,
                                        liked_post_id:  @post.id } }
    assert_redirected_to root_url
    assert_response :see_other
  end
end