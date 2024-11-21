require "test_helper"

class UsersSignupTest < ActionDispatch::IntegrationTest

  test "signup with valid data" do
    get login_path
    assert_difference 'User.count', 1 do
      post users_path, params: { user: { username:              "valid_name",
                                         password:              "password",
                                         password_confirmation: "password" } }
    end

    @new_user = User.find_by(username: "valid_name")
    assert_redirected_to @new_user
    follow_redirect!
    assert_select 'div.alert-success'
  end

  test "signup with invalid data" do
    get login_path
    assert_difference 'User.count', 0 do
      post users_path, params: { user: { username:              "michael",
                                         password:              "password",
                                         password_confirmation: "password1" } }
    end
    assert_select 'div.alert-danger',
                  "The form contains 2 errors:"
  end
end