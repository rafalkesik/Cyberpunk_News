require "test_helper"

class UsersControllerNotLoggedIn < ActionDispatch::IntegrationTest

  def setup
    @user       = users(:michael)
    @other_user = users(:dwight)
    @admin_user = users(:admin)
  end
end

class UsersControllerTest < UsersControllerNotLoggedIn

  test "should redirect show when not logged in" do
    get user_path(@other_user)
    assert_redirected_to login_url
    assert_response :see_other
    follow_redirect!
    assert_select 'div.alert'
  end
end

class LoggedInTest < UsersControllerNotLoggedIn

  def setup
    super
    login_as(@user)
  end

  test "should redirect destroy if not admin" do
    # skip "Admin functionality to be created"
    assert_difference 'User.count', 0 do
      delete user_path(@other_user)
    end
    assert_redirected_to root_url
    assert_response :see_other
    # Should also make a test for valid admin destroy action.
  end
end

class Admin < UsersControllerNotLoggedIn

  def setup
    super
    login_as(@admin_user)
  end
end

class AdminTest < Admin

  test "should delete a user if admin" do
    assert_difference 'User.count', -1 do
      delete user_path(@other_user)
    end
    assert_not User.all.include?(@other_user)
    assert_redirected_to users_url
    assert_response :see_other
    follow_redirect!
    assert_select 'div.alert-success'
  end
end
