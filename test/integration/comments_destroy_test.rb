require 'test_helper'

class CommentsDestroyAsAuthor < ActionDispatch::IntegrationTest
  def setup
    @comment    = comments(:two)
    @post       = @comment.post
    @author     = @comment.user
    @admin      = users(:admin)
    login_as(@author)
  end
end

class CommentsDestroyAsAuthorTest < CommentsDestroyAsAuthor
  test 'should destroy comment as author' do
    assert_difference 'Comment.count', -1 do
      delete comment_path(@comment), as: :turbo_stream
    end
    assert_select 'div.alert-success', 'The comment has been deleted.'
    assert_select 'turbo-stream[action="replace"][target=?]',
                  "comment-#{@comment.id}"
  end
end

class CommentsDestroyAsAdminTest < CommentsDestroyAsAuthor
  def setup
    super
    login_as(@author)
  end

  test 'should destroy comment as admin' do
    assert_difference 'Comment.count', -1 do
      delete comment_path(@comment), as: :turbo_stream
    end
  end
end

class SubcommentsDestroyTest < ActionDispatch::IntegrationTest
  def setup
    @comment    = comments(:one)
    @subcomment = comments(:child_of_one)
    @second_subcomment = comments(:second_child_of_one)
    @subsubcomment = comments(:grand_child_of_one)
    @post   = @comment.post
    @author = @comment.user
    login_as(@author)
  end

  test 'should hide parent comment on delete' do
    assert_difference 'Comment.count', 0 do
      delete comment_path(@comment), as: :turbo_stream
    end
    @comment.reload
    assert @comment.hidden
  end

  test 'should destroy hidden parents with no children on last child destroy' do
    delete comment_path(@comment), as: :turbo_stream

    assert_difference 'Comment.count', 0 do
      delete comment_path(@subcomment), as: :turbo_stream
    end
    @subcomment.reload
    assert @subcomment.hidden

    assert_difference 'Comment.count', -1 do
      delete comment_path(@second_subcomment), as: :turbo_stream
    end

    assert_difference 'Comment.count', -3 do
      delete comment_path(@subsubcomment), as: :turbo_stream
    end
  end
end
