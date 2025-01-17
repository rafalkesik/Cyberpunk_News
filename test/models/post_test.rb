require 'test_helper'

class PostTest < ActiveSupport::TestCase
  def setup
    @user = users(:michael)
    @post = Post.new(title: 'A valid title',
                     content: 'A valid content.',
                     link: 'https://www.valid-link.ru/nice-link/show',
                     points: 0,
                     user: @user)
  end

  test 'should be valid' do
    assert @post.valid?
  end

  test 'title should be non-empty' do
    @post.title = '   '
    assert_not @post.valid?
  end

  test 'link or content should be non-empty' do
    @post.link = @post.content = '   '
    assert_not @post.valid?
  end
end
