require "test_helper"

class UsersDeleteTest < ActionDispatch::IntegrationTest
  def setup
    @user        = users(:michael)
    @other_user  = users(:dwight)
    @posts_count = @other_user.posts.count
    @admin_user  = users(:admin)
    login_as(@admin_user)
  end

  test "should delete a user and its posts if admin" do
    assert_difference 'User.count', -1 do
      assert_difference 'Post.count', -(@posts_count) do
        delete user_path(@other_user)
      end
    end
    assert_not User.all.include?(@other_user)
    assert_redirected_to users_url
    assert_response :see_other
    follow_redirect!
    assert_select 'div.alert-success',
                  "Successfully deleted user: #{@other_user.username}."
  end
end
