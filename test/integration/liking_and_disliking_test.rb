require "test_helper"

class LikingAndDislikingTest < ActionDispatch::IntegrationTest

  def setup
    @post = posts(:one)
    @user = users(:admin)
    login_as(@user)
  end

  test "should like and unlike a post if logged in" do
    # likes a post
    get root_url
    assert_difference 'LikingRelation.count', 1 do
      post liking_relations_path,
           params: { liking_relation: { liked_post_id:  @post.id } }
    end
    assert_redirected_to root_url
    assert_response :see_other
    follow_redirect!
    assert_select "form[action=?]", liking_relations_path do |form|
      assert_select form, 'button>i.text-highlight'
      assert_select form, 'input[value=?]', @user.id
      assert_select form, 'input[value=?]', @post.id
    end
    # unlikes a post
    assert_difference 'LikingRelation.count', -1 do
      delete liking_relations_path,
             params: { liking_relation: { liked_post_id:  @post.id } }
    end
    assert_redirected_to root_url
    assert_response :see_other
    follow_redirect!
    assert_select 'form[action=?]', liking_relations_path do |form|
      assert_select form, 'input[value=?]', @user.id
      assert_select form, 'input[value=?]', @post.id
    end
  end

  test "should render likes/unlikes & points correctly WITH TURBO" do
    # likes a post
    get root_url
    post liking_relations_path, as: :turbo_stream,
          params: { liking_relation: { liking_user_id: @user.id,
                                       liked_post_id:  @post.id } }
    # checks the like icon change
    assert_select "form[action=?]", liking_relations_path do |form|
      assert_select form, 'button>i.text-highlight'
      assert_select form, 'input[value=?]', @user.id
      assert_select form, 'input[value=?]', @post.id
    end
    # checks if the points changed
    assert_select 'turbo-stream[target=?]', "post-#{@post.id}-points" do
      text = pluralize(@post.points, "point")
      assert_select 'template', text
    end
    # unlikes a post
    delete liking_relations_path, as: :turbo_stream,
            params: { liking_relation: { liking_user_id: @user.id,
                                         liked_post_id:  @post.id } }
    # checks the like icon change
    assert_select 'form[action=?]', liking_relations_path do |form|
      assert_select form, 'input[value=?]', @user.id
      assert_select form, 'input[value=?]', @post.id
    end
    # checks if the points changed
    assert_select 'turbo-stream[target=?]', "post-#{@post.id}-points" do
      text = pluralize(@post.points, "point")
      assert_select 'template', text
    end
  end
end
