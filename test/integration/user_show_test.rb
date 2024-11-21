require "test_helper"

class UserShowTest < ActionDispatch::IntegrationTest
  
  def setup
    @user       = users(:michael)
    @other_user = users(:dwight)
    login_as(@user)
  end

  test "should show a different user if logged in" do
    get user_path(@other_user)
    assert_template 'users/show'
    assert_select 'h1', @other_user.username
    assert_select 'form[action=?]', "/sessions", count: 0
    assert_select 'form[action=?]', "/users/#{@other_user.id}", count: 0
  end

  test "should show self-user correctly if logged in" do
    get user_path(@user)
    assert_select 'h1', @user.username
    assert_select 'form[action=?]', "/sessions", count: 1
    assert_select 'form[action=?]', "/users/#{@user.id}", count: 1
  end
end
