require 'test_helper'

class CommentsCreateTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:michael)
    @post = posts(:one)
    login_as(@user)
  end

  test 'should create a valid comment' do
    assert_difference 'Comment.count', 1 do
      @comment = post comments_path,
                      as: :turbo_stream,
                      params: { comment: { post_id: @post.id,
                                           user_id: @user.id,
                                           content: 'Valid content' } }
    end

    assert_select 'turbo-stream[target=?]', 'flash-messages' do
      assert_select 'template' do
        assert_select 'div.alert-success', 'Comment submitted.'
      end
    end

    assert_select 'turbo-stream[target=?]', 'comments-list-' do
      assert_select 'template', partial: 'comments/comment',
                                locals: { comment: @comment,
                                          current_user: @user }
    end

    assert_select 'turbo-stream[target=?]', 'submit-comment-form' do
      assert_select 'template', partial: 'comments/submit_comment_form',
                                locals: { post: @post }
    end
  end

  test 'should not create an invalid comment' do
    assert_difference 'Comment.count', 0 do
      post comments_path,
           as: :turbo_stream,
           params: { comment: { post_id: @post.id,
                                user_id: @user.id,
                                content: '  ' } }
    end
    assert_select 'div.alert-danger', 'Comment not valid.'

    assert_select 'turbo-stream[target=?]', 'flash-messages' do
      assert_select 'template' do
        assert_select 'div.alert-danger', 'Comment not valid.'
      end
    end
  end
end
