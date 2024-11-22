require "test_helper"

class PostsCreateTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:michael)
    login_as(@user)
  end

  test "should create a valid post" do
    assert_difference '@user.posts.count', 1 do
      post posts_path, params: { post: { title: "Valid title",
                                        content: "Valid content",
                                        link: "https://cool_site.com/valid_link",
                                        points: 0 } }
    end
    assert_redirected_to posts_path
    assert_response :see_other
    follow_redirect!
    assert_select 'div.alert-success'
    # makes sure that the new post is listed at /posts
    assert_select 'a', "Valid title"
  end

  test "should not create an invalid post" do
    assert_difference '@user.posts.count', 0 do
      post posts_path, params: { post: { title: "  ",
                                        content: "",
                                        link: "",
                                        points: 0 } }
    end    
    assert_select 'div.error-explanation'
  end
end
