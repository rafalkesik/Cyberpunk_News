require 'test_helper'

class LikingAndDislikingTest < ActionDispatch::IntegrationTest
  def setup
    @post = posts(:one)
    @user = users(:admin)
    login_as(@user)
  end

  test 'should render likes/unlikes & points correctly WITH TURBO' do
    # likes a post
    post liking_relations_path,
         as: :turbo_stream,
         params: { liking_relation: { liking_user_id: @user.id,
                                      liked_post_id: @post.id } }
    # checks the like icon change
    assert_select 'form[action=?]', liking_relations_path do |form|
      assert_select form, 'button>i.text-highlight'
      assert_select form, 'input[value=?]', @user.id
      assert_select form, 'input[value=?]', @post.id
    end
    # checks if the points changed
    assert_select 'turbo-stream[target=?]', "post-#{@post.id}-points" do
      text = pluralize(@post.points, 'point')
      assert_select 'template', text
    end
    # unlikes a post
    delete liking_relations_path,
           as: :turbo_stream,
           params: { liking_relation: { liking_user_id: @user.id,
                                        liked_post_id: @post.id } }
    # checks if icon changed
    assert_select 'form[action=?]', liking_relations_path do |form|
      assert_select form, 'input[value=?]', @user.id
      assert_select form, 'input[value=?]', @post.id
    end
    # checks if the points changed
    assert_select 'turbo-stream[target=?]', "post-#{@post.id}-points" do
      text = pluralize(@post.points, 'point')
      assert_select 'template', text
    end
  end
end
