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
        delete user_path(@other_user),
               as: :turbo_stream
      end
    end
    assert_select 'turbo-stream[action=replace][target=?]', 'flash-messages' do
      assert_select 'template',
                    "Successfully deleted user: #{@other_user.username}."
    end
    assert_select 'turbo-stream[action=remove][target=?]',
                  "user-#{@other_user.id}"
  end
end
