require "test_helper"

class PostsDestroyAdmin < ActionDispatch::IntegrationTest

  def setup
    @post = posts(:one)
    @admin_user = users(:admin)
    login_as(@admin_user)
  end
end

class PostsDestroyAdminTest < PostsDestroyAdmin

  test "should destroy a post as an admin" do
    get posts_path
    assert_difference 'Post.count', -1 do
      delete post_path(@post)
    end
    assert_redirected_to posts_path
    assert_response :see_other
    follow_redirect!
    assert_select 'div.alert-success', "Post deleted."
  end

  test "should destroy a post as an admin WITH TURBO" do
    get posts_path
    assert_difference 'Post.count', -1 do
      delete post_path(@post), as: :turbo_stream
    end
    assert_select 'turbo-stream[target=?]', "flash-messages" do
      assert_select 'template', "Post deleted."  
    end
    target = "post_#{@post.id}"
    assert_select 'turbo-stream[action="remove"][target=?]', target
  end
end

class PostsDestroyAuthorTest < PostsDestroyAdmin

  def setup
    super
    @user_author = @post.user
    login_as(@user_author)
  end
 
  test "should destroy a post as post's author" do
    get posts_path
    assert_difference 'Post.count', -1 do
      delete post_path(@post)
    end
    assert_redirected_to posts_path
    assert_response :see_other
    follow_redirect!
    assert_select 'div.alert-success', "Post deleted."
  end
end