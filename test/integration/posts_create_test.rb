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
    assert_select 'div.alert-success', "News Post created!"
    # makes sure that the new post is listed at /posts
    assert_select 'a', "Valid title"
  end

  test "should create a valid post WITH TURBO" do
    assert_difference '@user.posts.count', 1 do
      post posts_path, as: :turbo_stream,
                       params: { post: { title: "Valid title",
                                         content: "Valid content",
                                         link: "https://cool_site.com/",
                                         points: 0 } }
    end
    assert_redirected_to posts_path
    assert_response :see_other
    follow_redirect!
    assert_select 'div.alert-success', "News Post created!"
    # assert_select 'turbo-stream[target=?]', 'flash-messages' do
    #   assert_select 'template', "News Post created!"
    # end
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

  test "should not create an invalid post WITH TURBO" do
    post posts_path, as: :turbo_stream,
                     params: { post: { title: "  ",
                                       content: "",
                                       link: "",
                                       points: 0 } }    
    puts @response.body
    assert_select 'turbo-stream[target=?]', 'error-messages' do
      assert_select 'template', "Tittle can't be blank"
    end
    # tu potrzeba dodać respond_to.turbo_stream { tu podmienić error-messages div. } I w ogóle error-messages div powinno zawsze istnieć jako turbo frame w formsach.
  end
end
