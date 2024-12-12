require "test_helper"

class NotLoggedIn < ActionDispatch::IntegrationTest

  def setup
    @comment    = comments(:one)
    @author     = users(:dwight)
    @other_user = users(:michael)
    @admin      = users(:admin)
  end
end

class NotLoggedInTest < NotLoggedIn
  test "should redirect create if not logged in" do
    post comments_path, as: :turbo_stream
    assert_redirected_to login_url
    assert_response :see_other
    follow_redirect!
    assert_select 'div.alert-warning', 'Log in to submit comments.'
  end

  test "should redirect destroy if not logged in" do
    delete comment_path(@comment), as: :turbo_stream
    assert_redirected_to login_url
    assert_response :see_other
    follow_redirect!
    assert_select 'div.alert-warning', 'Log in to submit comments.'
  end
end

class LoggedInAsOtherUser < NotLoggedIn
  def setup
    super
    login_as(@other_user)
  end

  test "should redirect destroy if not admin nor author" do
    delete comment_path(@comment), as: :turbo_stream
    assert_redirected_to root_url
    assert_response :see_other
  end
end
