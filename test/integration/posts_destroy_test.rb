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
    assert_difference 'Post.count', -1 do
      delete post_path(@post)
    end
  end
end

class PostsDestroyAuthorTest < PostsDestroyAdmin

  def setup
    super
    @user_author = @post.user
    login_as(@user_author)
  end
 
  test "should destroy a post as post's author" do
    assert_difference 'Post.count', -1 do
      delete post_path(@post)
    end
  end
end