require "test_helper"

class CommentsDestroyAsAuthor < ActionDispatch::IntegrationTest
  def setup
    @comment    = comments(:two)
    @post       = @comment.post
    @author     = @comment.user
    @admin      = users(:admin)
    login_as(@author)
  end

  test "should destroy comment as author" do
    assert_difference 'Comment.count', -1 do
      delete comment_path(@comment), as: :turbo_stream
    end
    assert_select 'div.alert-success', 'Comment deleted'
    assert_select 'turbo-stream[action="remove"][target=?]',
                  "comment-#{@comment.id}"
  end
end

class CommentsDestroyAsAdminTest < CommentsDestroyAsAuthor
  def setup
    super
    login_as(@author)
  end

  test "should destroy comment as admin" do
    assert_difference 'Comment.count', -1 do
      delete comment_path(@comment), as: :turbo_stream
    end
  end
end