require "test_helper"

class CommentLikingRelationsControllerTest < ActionDispatch::IntegrationTest

  test "should redirect create if not logged in" do
    assert_difference 'CommentLikingRelation.count', 0 do
      post comment_liking_relations_path,
           params: { liking_user_id: 1,
                     liked_comment_id: 1 }
    end
    assert_redirected_to login_url
    assert_response :see_other
    follow_redirect!
    assert_select 'div.alert-warning', 'You must be logged in to upvote.'
  end
end
