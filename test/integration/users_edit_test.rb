require "test_helper"

class UsersEditTest < ActionDispatch::IntegrationTest

  def setup
    @user       = users(:michael)
    @other_user = users(:dwight)
    login_as(@user)
  end

  test "should edit self-user with valid data" do
    get user_path(@user)
    patch user_path(@user), as: :turbo_stream,
          params: { user: { username:              @user.username,
                            password:              "NewPass",
                            password_confirmation: "NewPass" } }
    @user.reload
    assert @user.authenticate("NewPass")
    assert_select 'turbo-stream[target=?]', 'flash-messages' do
      assert_select 'template', "Password updated."
    end
  end

  test "should not update self-user with invalid data" do
    get user_path(@user)
    patch user_path(@user),
          as: :turbo_stream,
          params: { user: 
                  { username:              @user.username,
                    password:              "NewPass",
                    password_confirmation: "Invalid" } }
    @user.reload
    assert_not @user.authenticate("NewPass")
    assert_select "turbo-stream[target=?]", 'flash-messages' do
      assert_select 'template', "Passwords don't match."
    end
  end  

  test "should redirect update of a different user" do
    get user_path(@other_user)
    patch user_path(@other_user),
          as: :turbo_stream,
          params: { user: { username: @other_user.username,
                            password:              "NewPass",
                            password_confirmation: "NewPass" } }
    @other_user.reload
    assert_not @other_user.authenticate("NewPass")
    assert_redirected_to root_url
    assert_response :see_other
    assert_select 'div.alert', count: 0
  end
end
