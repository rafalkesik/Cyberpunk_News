require "test_helper"

class LogoutTest < ActionDispatch::IntegrationTest
  
  def setup
    @user = users(:michael)
    login_as(@user)
  end
  
  test "should logout" do
    delete sessions_path, as: :turbo_stream
    assert_nil session[:user_id]
    assert_redirected_to root_url
    assert_response :see_other
    follow_redirect!
    assert_select 'div.alert-success', "Logged out successfully."
  end
end
