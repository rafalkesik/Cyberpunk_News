require "test_helper"

class CommentLikingRelationsControllerTest < ActionDispatch::IntegrationTest

  test "should flash warning on create if not logged in" do
    assert_difference 'CommentLikingRelation.count', 0 do
      post comment_liking_relations_path,
           as: :turbo_stream,
           params: { liking_user_id: 1,
                     liked_comment_id: 1 }
    end
    assert_select 'turbo-stream[target=?]', 'flash-messages' do
      assert_select 'template', partial: 'layouts/flash'
    end
    assert_select 'div.alert-warning', 'You must be logged in to upvote.'
  end
end

class CommentLikingRelationsOtherUserTest < ActionDispatch::IntegrationTest
  def setup
    @user       = users(:michael)
    @other_user = users(:dwight)
    @comment    = comments(:one)
    login_as(@other_user)
  end

  test "should flash warning on create if not the right user" do
    post comment_liking_relations_path,
         as: :turbo_stream,
         params: { comment_liking_relation: { liking_user_id: @user.id,
                                              liked_comment_id: @comment.id } }
    assert_select 'turbo-stream[target=?]', 'flash-messages' do
      assert_select 'template', partial: 'layouts/flash'
    end
    assert_select 'div.alert-warning', 'You must log in to like.'
  end
end