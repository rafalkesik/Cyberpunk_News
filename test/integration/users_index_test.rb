require 'test_helper'

class UsersIndexTest < ActionDispatch::IntegrationTest
  def setup
    @user       = users(:michael)
    @admin_user = users(:admin)
    login_as(@admin_user)
  end

  test 'users index page' do
    get users_path
    User.all.each do |user|
      assert_select 'a[href=?]', user_path(user), user.username
      assert_select 'form[action=?]', user_path(user) if !user.admin
    end
  end
end
