require "test_helper"

class UsersControllerNotLoggedIn < ActionDispatch::IntegrationTest

  def setup
    @user       = users(:michael)
    @other_user = users(:dwight)
    @admin_user = users(:admin)
  end
end

class UsersControllerTest < UsersControllerNotLoggedIn

  test "should redirect index when not logged in" do
    get users_path
    assert_redirected_to login_url
    assert_response :see_other
    follow_redirect!
    assert_select 'div.alert', "Please log in to view that page."
  end

  test "should redirect show when not logged in" do
    get user_path(@other_user)
    assert_redirected_to login_url
    assert_response :see_other
    follow_redirect!
    assert_select 'div.alert', "Please log in to view that page."
  end

  test "should redirect destroy when not logged in" do
    delete user_path(@other_user)
    assert_redirected_to login_url
    assert_response :see_other
    follow_redirect!
    assert_select 'div.alert', "Please log in to view that page."
  end
end

class LoggedInTest < UsersControllerNotLoggedIn

  def setup
    super
    login_as(@user)
  end

  test "should redirect update if not the right user" do
    patch user_path(@other_user)
    assert_redirected_to root_url
    assert_response :see_other
  end

  test "should redirect destroy if not admin" do
    assert_difference 'User.count', 0 do
      delete user_path(@other_user)
    end
    assert_redirected_to root_url
    assert_response :see_other
  end
end
