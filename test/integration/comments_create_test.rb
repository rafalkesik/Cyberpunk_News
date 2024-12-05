require "test_helper"

class CommentsCreateTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:michael)
    @post = posts(:one)
    login_as(@user)
  end

  test "should create a valid comment" do
    assert_difference 'Comment.count', 1 do 
      post comments_path,
          params: { comment: { post_id: @post.id,
                               user_id: @user.id,
                               content: "Valid content"
          } }
    end

    assert_redirected_to post_path(@user)
    assert_response :see_other
    follow_redirect!
    assert_select 'div.alert-success', 'Comment submitted.'
  end

  test "should not create an invalid comment" do
    assert_difference 'Comment.count', 0 do 
      post comments_path,
          params: { comment: { post_id: @post.id,
                               user_id: @user.id,
                               content: "  "
          } }
    end
    assert_select 'div.alert-danger', 'Comment not valid.'
  end
end
