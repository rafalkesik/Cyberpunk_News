require "test_helper"

class LikingAndDislikingCommentsTest < ActionDispatch::IntegrationTest
  def setup
    @user    = users(:michael)
    @post    = posts(:one)
    @comment = comments(:one)
    login_as(@user)

    @relation = comment_liking_relations(:one_likes_two)
    @relation_user = @relation.liking_user
    @relation_comment = @relation.liked_comment
    @relation_post = @relation_comment.post
  end
  
  test "should like a comment if logged in" do

    assert_difference 'CommentLikingRelation.count', 1 do
      post comment_liking_relations_path,
          as: :turbo_stream,
          params: { comment_liking_relation: { liked_comment_id: @comment.id,
                                               liking_user_id:   @user.id } }
    end

    assert_select 'turbo-stream[target=?]', "comment-#{@comment.id}-upvote" do
      assert_select 'template',
                    partial: 'comments/comment_upvote_form',
                             data: @comment.icon_data(@current_user),
                             comment: @comment,
                             current_user: @current_user
    end

    assert_select 'turbo-stream[target=?]', "comment-#{@comment.id}-points" do
      assert_select 'template', "#{@comment.points} points"
    end
  end

  test "should flash when liking a deleted comment" do
    assert_difference 'CommentLikingRelation.count', 0 do
      post comment_liking_relations_path,
          as: :turbo_stream,
          params: { comment_liking_relation: { liked_comment_id: @relation,
                                               liking_user_id:   @user.id} }
    end

    assert_select 'div.alert-danger',
                  'The comment has been deleted.'
  end

  test "should unlike a comment if logged in" do
    assert_difference 'CommentLikingRelation.count', -1 do
      delete comment_liking_relations_path,
             as: :turbo_stream,
             params: { comment_liking_relation:
                        { liked_comment_id: @relation_comment.id,
                          liking_user_id:   @relation_user.id } }
    end

  end

  test "should redirect when unliking a deleted comment" do
    get post_path(@relation_post)
    assert_difference 'CommentLikingRelation.count', 0 do
      delete comment_liking_relations_path,
          as: :turbo_stream,
          params: { comment_liking_relation:
                    { liked_comment_id: 999,
                      liking_user_id:   @relation_user.id} },
          # This is needed, as we redirect back to request referrer in destroy action.
          headers: { "HTTP_REFERER" => post_path(@relation_post) }

    end

    assert_redirected_to post_path(@relation_post)
    assert_response :see_other
    follow_redirect!
    assert_select 'div.alert-danger',
                  'The comment has been deleted.'
  end
end
