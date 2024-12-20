require "test_helper"

class PostsControllerNotLoggedIn < ActionDispatch::IntegrationTest

  def setup
    @post = posts(:two)
  end
end

class PostsControllerNotLoggedInTest < PostsControllerNotLoggedIn

  test "should redirect new if not logged in" do
    get new_post_path, as: :turbo_stream
    assert_redirected_to login_url
    assert_response :see_other 
    follow_redirect!
    assert_select 'div.alert-warning', "Log in to submit posts."
  end

  test "should redirect create if not logged in" do
    post posts_path, as: :turbo_stream
    assert_redirected_to login_url
    assert_response :see_other 
    follow_redirect!
    assert_select 'div.alert-warning', "Log in to submit posts."
  end

  test "should redirect destroy if not logged in" do
    delete post_path(@post), as: :turbo_stream
    assert_redirected_to login_url
    assert_response :see_other
    follow_redirect!
    assert_select 'div.alert-warning', "Log in to submit posts."
  end

  test "should render show" do
    get post_path(@post), as: :turbo_stream
    assert_template 'posts/show'
    assert_select 'a', @post.title
    assert_select 'p', @post.content
    assert_select 'form'
  end
end

class PostsControllerLoggedInTest < PostsControllerNotLoggedIn

  def setup
    super
    @user = users(:michael)
    login_as(@user)
  end

  test "should redirect destroy if logged in as non-admin & non-author" do
    delete post_path(@post), as: :turbo_stream
    assert_redirected_to root_url
    assert_response :see_other
  end

  test "should render new if logged in" do
    get new_post_path, as: :turbo_stream
    assert_template 'posts/new'
    assert_select 'form[action=?]', "/en/posts"
  end
end
