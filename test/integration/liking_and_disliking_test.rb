require "test_helper"

class LikingAndDislikingTest < ActionDispatch::IntegrationTest

  def setup
    @post = posts(:one)
    @user = users(:admin)
    login_as(@user)
  end

  test "should like and unlike a post if logged in" do
    get root_url
    assert_difference 'LikingRelation.count', 1 do
      post liking_relations_path,
           params: { liking_relation: { liking_user_id: @user.id,
                                        liked_post_id:  @post.id } }
    end
    @relation = LikingRelation.where(liking_user_id: @user.id,
                                     liked_post_id:  @post.id).first
    assert_redirected_to root_url
    assert_response :see_other
    follow_redirect!
    assert_select "form[action=?]>button>i.text-highlight",
                  liking_relations_path

    assert_difference 'LikingRelation.count', -1 do
      delete liking_relations_path,
             params: { liking_relation: { liking_user_id: @user.id,
                                          liked_post_id:  @post.id } }
    end
    assert_redirected_to root_url
    assert_response :see_other
    follow_redirect!
    assert_select 'form[action=?]', liking_relations_path do |form|
      assert_select form, 'input[value=?]', @user.id
      assert_select form, 'input[value=?]', @post.id
    end
  end
end
