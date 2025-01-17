require 'test_helper'

class PostsIndexTest < ActionDispatch::IntegrationTest
  test 'should render all posts' do
    get posts_path
    Post.all.each do |post|
      assert_select 'a[href=?]', post_path(post), post.title
      assert_select 'a[href=?]', post_path(post),
                    "Comments: #{post.comments.count}"
      assert_select 'a[href=?]', user_path(post.user), post.user.username
      assert_select 'a[href=?]', post.link, "Read at: #{post.short_link}"
    end
  end
end

class PostsIndexAdminTest < ActionDispatch::IntegrationTest
  def setup
    @user       = users(:michael)
    @other_user = users(:dwight)
    @admin_user = users(:admin)
    login_as(@admin_user)
  end

  test 'should show delete buttons for all users' do
    get posts_path
    assert_select 'input[type="submit"][value="delete"]',
                  count: Post.count
  end
end
