require "test_helper"

class PostShowTest < ActionDispatch::IntegrationTest

  def setup
    @post     = posts(:one)
    @comments = @post.comments
    get post_path(@post)
  end
  test "should render layout" do
    assert_template 'posts/show'
    # checks rendering of post
    assert_select 'a[href=?]', post_path(@post),
                               @post.title
    assert_select 'a[href=?]', post_path(@post),
                               "#{pluralize(@post.comments.count, 'comment')}"
    assert_select 'a[href=?]', user_path(@post.user),
                               @post.user.username
    assert_select 'a[href=?]', @post.link
                               @post.short_link
    assert_select 'p', @post.content
    # checks if new post form is rendered
    assert_select 'form[action=?][method=?]',
                  '/comments', 'post'
    # checks if comments are rendered
    assert_select 'ul' do
      @comments.each_with_index do |comment, index|
        assert_select 'li[id=?]', "comment-#{index}" do
          assert_select 'div.comment-content' do
            assert_select 'div.comment-text',
                          comment.content
          end
        end
      end
    end
  end
end
