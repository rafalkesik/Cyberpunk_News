require "test_helper"

class UserShow < ActionDispatch::IntegrationTest 

  def setup
    @user        = users(:michael)
    @other_user  = users(:dwight)
    login_as(@user)
  end
end

class UserShowTest < UserShow

  test "should show a different user if logged in as non-admin" do
    get user_path(@other_user)
    assert_template 'users/show'
    assert_select 'h1', @other_user.username
    assert_select 'form[action=?]', "/sessions", count: 0
    assert_select 'form[action=?]', "/users/#{@other_user.id}", count: 0
    @other_user.posts.each do |post|
      assert_select 'a', post.title
    end
  end

  test "should show self-user correctly if logged in" do
    get user_path(@user)
    assert_select 'h1', @user.username
    assert_select 'form[action=?]', "/sessions", count: 1
    assert_select 'form[action=?]', "/users/#{@user.id}", count: 1
    @user.posts.each do |post|
      assert_select 'a', post.title
    end
    assert_select 'input[type="submit"][value=?]',
    "delete"
  end
end

class UserShowAdminTest < UserShow

  def setup
    super
    @admin_user = users(:admin)
    login_as(@admin_user)
  end

  test "should render delete buttons on other users" do
    get user_path(@other_user)
    assert_select 'input[type="submit"][value=?]',
                  "delete"
  end
end