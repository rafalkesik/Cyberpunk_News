require "test_helper"

class LoginTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:michael)
  end

  test "should render login & signup forms" do
    get login_path
    assert_template 'sessions/login'
    assert_select 'h3', 'Login'
    assert_select 'h3', 'Sign up'
    assert_select 'form[action=?][method=?]', "/en/sessions", "post"
    assert_select 'form[action=?][method=?]', "/en/users",    "post"
  end

  test "should login with valid data" do
    get login_path
    post sessions_path,
         as: :turbo_stream,
         params: { user: { username: @user.username,
                           password:              "pass",
                           password_confirmation: "pass" } }
    assert_equal session[:user_id], @user.id
    assert_redirected_to @user
    follow_redirect!
    assert_select 'div.alert-success', "Logged in successfully."
  end

  test "should not login with invalid data" do
    get login_path
    post sessions_path, as: :turbo_stream,
                        params: { user: { username: @user.username,
                                          password:              "invalid",
                                          password_confirmation: "invalid" } }
    assert_nil session[:user_id]
    assert_select 'turbo-stream[action="update"][target=?]',
                  'flash-messages' do
      assert_select 'template', 'Username or password are incorrect. Try again.'
    end
  end
end
