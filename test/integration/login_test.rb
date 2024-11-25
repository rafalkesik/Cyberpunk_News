require "test_helper"

class LoginTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:michael)
  end

  test "should login with valid data" do
    get login_path
    post sessions_path, params: { user: { username: @user.username,
                                          password:              "pass",
                                          password_confirmation: "pass" } }
    assert_equal session[:user_id], @user.id
    assert_redirected_to @user
    follow_redirect!
    assert_select 'div.alert-success'
  end

  test "should redirect login with invalid data" do
    get login_path
    post sessions_path, params: { user: { username: @user.username,
                                          password:              "invalid",
                                          password_confirmation: "invalid" } }
    assert_nil session[:user_id]
    assert_redirected_to login_url
    assert_response :see_other
    follow_redirect!
    assert_select 'div.alert-danger'
  end
end
