require "test_helper"

class LikingAndDislikingCommentsTest < ActionDispatch::IntegrationTest
  def setup
    @user    = users(:michael)
    @post    = posts(:one)
    @comment = comments(:one)
    login_as(@user)
  end
  
  test "should like a post if logged in" do
    skip 'Test not ready for turbo'
    assert_difference 'CommentLikingRelation.count', 1 do
      post comment_liking_relations_path,
          as: :turbo_stream,
          params: { comment_liking_relation: { liked_comment_id: @comment.id } }
    end
    # assert_redirected_to post_url(@post)
    # assert_response :see_other
    # follow_redirect!
    # assert_select 'div.alert-success', 'Comment liked.'
  end

  test "should redirect liking non-existent post" do
    skip 'Test not ready for turbo'
    assert_difference 'CommentLikingRelation.count', 0 do
      post comment_liking_relations_path,
          as: :turbo_stream,
          params: { comment_liking_relation: { liked_comment_id: 9999 } }
    end
    # assert_redirected_to root_url
    # assert_response :see_other
    # follow_redirect!
    # assert_select 'div.alert-danger',
    #               'The post has been deleted.'
  end

  test "should unlike a post if logged in" do
    skip 'destroy action not ready'
  end

  test "should redirect unliking non-existent post" do
    skip 'destroy action not ready'
  end
end
