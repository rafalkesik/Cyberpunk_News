require "test_helper"

class CommentsDestroyAsAuthor < ActionDispatch::IntegrationTest
  def setup
    @comment    = comments(:one)
    @author     = users(:dwight)
    @admin      = users(:admin)
    login_as(@author)
  end

  test "should destroy comment as author" do
    assert_difference 'Comment.count', -1 do
      delete comment_path(@comment)
    end
    assert_redirected_to post_url(@comment.post)
    assert_response :see_other
    follow_redirect!
    assert_select 'div.alert-success', 'Comment deleted'
  end
end

class CommentsDestroyAsAdminTest < CommentsDestroyAsAuthor
  def setup
    super
    login_as(@author)
  end

  test "should destroy comment as admin" do
    assert_difference 'Comment.count', -1 do
      delete comment_path(@comment)
    end
    assert_redirected_to post_url(@comment.post)
    assert_response :see_other
    follow_redirect!
    assert_select 'div.alert-success', 'Comment deleted'  
  end
end